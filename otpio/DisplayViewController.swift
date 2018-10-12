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

class DisplayViewController: UIViewController {
    
    var shouldScan: Bool = false
    
    let topBar: SystemView
    let topLabel: SystemLabel
    let add: SystemButton
    
    let codes: CodesView
    
    lazy var readerVC: QRCodeReaderViewController = {
        let b = QRCodeReaderViewControllerBuilder {
            $0.reader = QRCodeReader(metadataObjectTypes: [.qr], captureDevicePosition: .back)
        }
        
        return QRCodeReaderViewController(builder: b)
    }()
    
    init() {
        topBar = SystemView()
        topBar.backgroundColor = .flatBlack
        
        topLabel = SystemLabel(.center, size: 20)
        topLabel.text = "My Codes"
        topBar.addSubview(topLabel)
        
        add = SystemButton(faType: .normal, backgroundColor: .clear, text: "\u{f067}")
        topBar.addSubview(add)
        
        codes = CodesView()
        
        super.init(nibName: nil, bundle: nil)
        
        view.addSubview(topBar)
        view.addSubview(codes)
        
        add.addTarget(self, action: #selector(DisplayViewController.scanCode), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .flatBlackDark
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if shouldScan { scanCode(); shouldScan = false }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        topBar.anchorAndFillEdge(.top, xPad: 0, yPad: 0, otherSize: 90)
        topLabel.anchorToEdge(.bottom, padding: 15, width: 100, height: 22)
        add.anchorInCorner(.bottomLeft, xPad: 5, yPad: 15, width: 30, height: 30)
        
        codes.anchorToEdge(.bottom, padding: 40, width: view.width * 0.85, height: view.height * 0.75)
    }
    
    @objc func scanCode() {
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
