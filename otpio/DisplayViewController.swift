//
//  DisplayViewController.swift
//  otpio
//
//  Created by Mason Phillips on 10/8/18.
//  Copyright © 2018 Matrix Studios. All rights reserved.
//

import UIKit
import ChameleonFramework
import Neon
import QRCodeReader
import AVFoundation
import OneTimePassword
import RetroProgress
import SCLAlertView

class DisplayViewController: UIViewController {
    
    var shouldScan: Bool = false
    
    let codes: CodesView
    var add: UIBarButtonItem {
        let b = UIBarButtonItem(title: "\u{f029}", style: .plain, target: self, action: #selector(DisplayViewController.scanCode))
        b.setTitleTextAttributes(FAREGULAR_ATTR, for: .normal)
        b.tintColor = .flatWhite
        
        return b
    }
    
    lazy var readerVC: QRCodeReaderViewController = {
        let b = QRCodeReaderViewControllerBuilder {
            $0.reader = QRCodeReader(metadataObjectTypes: [.qr], captureDevicePosition: .back)
        }
        
        return QRCodeReaderViewController(builder: b)
    }()
    
    init() {
        codes = CodesView()
        
        super.init(nibName: nil, bundle: nil)
        
        view.addSubview(codes)
        
        registerForPreviewing(with: self, sourceView: codes)
        
        navigationItem.title = "My Codes"
        navigationItem.rightBarButtonItem = add
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .flatBlackDark
        System.sharedInstance.fetchFromCloud()        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if shouldScan { scanCode(); shouldScan = false }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        codes.anchorToEdge(.bottom, padding: 40, width: view.width * 0.85, height: view.height * 0.8)
    }
    
    @objc func scanCode() {
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: true, showCircularIcon: true
        )
        let alert = SCLAlertView(appearance: appearance)
        let text = alert.addTextField("OTP URL")
        alert.addButton("Use OTP URL") {
            guard let r = text.text else { return }
            System.sharedInstance.textCallback(result: r)
        }
        alert.addButton("Scan QR Code") {
            self.showScanView()
        }
        
        let icon = UIImage.fontAwesomeIcon("\u{f029}", textColor: .flatWhite, size: CGSize(width: 100, height: 100))
        alert.showInfo("Add a Code", subTitle: "Enter a OTP URL, or scan a QR Code", circleIconImage: icon)
    }
    
    private func showScanView() {
        readerVC.delegate = self
        readerVC.completionBlock = { (result: QRCodeReaderResult?) in
            System.sharedInstance.qrCallback(result: result)
        }
        
        readerVC.modalPresentationStyle = .formSheet
        self.present(readerVC, animated: true, completion: nil)
    }
}

extension DisplayViewController: QRCodeReaderViewControllerDelegate {
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        reader.stopScanning()
        dismiss(animated: true, completion: nil)
    }
    
    func reader(_ reader: QRCodeReaderViewController, didSwitchCamera newCaptureDevice: AVCaptureDeviceInput) {
        let name = newCaptureDevice.device.localizedName
        print("Switching to \(name)")
    }
    
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        reader.stopScanning()
        dismiss(animated: true, completion: nil)
    }
}

extension DisplayViewController: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        show(viewControllerToCommit, sender: self)
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let index = self.codes.indexPathForRow(at: location) else { return nil }
        guard let cell = self.codes.cellForRow(at: index) as? CodeTableViewCell else { return nil }
        guard let token = cell.token else { return nil }
        
        let detailVC = codes.detailVC
        
        detailVC.configure(with: token)
        
        //detailVC.preferredContentSize = CGSize(width: 0.0, height: 300)
        previewingContext.sourceRect = cell.frame
        
        return detailVC
    }
}

