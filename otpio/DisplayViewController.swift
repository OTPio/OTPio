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
    let progress: ProgressView
    
    let codes: SystemView
    var codeCont: [CodeView]
    
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

        progress = ProgressView(frame: CGRect())
        
        add = SystemButton(faType: .normal, backgroundColor: .clear, text: "\u{f067}")
        topBar.addSubview(add)
        
        codes = SystemView()
        codes.backgroundColor = .flatBlack
        
        codeCont = []
        
        super.init(nibName: nil, bundle: nil)
        
        view.addSubview(topBar)
        view.addSubview(codes)
        
        view.addSubview(progress)
        
        add.addTarget(self, action: #selector(DisplayViewController.scanCode), for: .touchUpInside)

        System.sharedInstance.listener = self        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .flatBlackDark
        
        progress.layer.cornerRadius = 15
        progress.layer.borderColor = UIColor.flatBlack.cgColor
        progress.trackColor = .clear
        progress.separatorColor = .clear
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if shouldScan { scanCode(); shouldScan = false }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        topBar.anchorAndFillEdge(.top, xPad: 0, yPad: 0, otherSize: 90)
        topLabel.anchorToEdge(.bottom, padding: 15, width: 100, height: 22)
        add.anchorInCorner(.bottomRight, xPad: 5, yPad: 15, width: 30, height: 30)
        
        codes.anchorToEdge(.bottom, padding: 40, width: view.width * 0.85, height: view.height * 0.75)
        codes.roundCorners()
        
        progress.alignBetweenVertical(align: .underCentered, primaryView: topBar, secondaryView: codes, padding: 20, width: view.width * 0.85)
        
        if codeCont.count == 0 { return }
        codes.groupAgainstEdge(group: .vertical, views: codeCont, againstEdge: .top, padding: 15, width: codes.width * 0.92, height: 60)
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

extension DisplayViewController: TokenOperationsListener {
    func tokensUpdated(tokens t: Array<Token>, time: Float) {
        if codeCont.count == 0 && t.count == 0 { return }
        if t.count > 0 && codeCont.count == 0 {
            // Creating Views
            for token in t {
                let c = CodeView()
                
                let p = token.issuer
                let u = token.name
                let s = token.currentPassword!
                c.set(provider: p, user: u, code: s)
                
                codes.addSubview(c)
                codeCont.append(c)
                view.setNeedsLayout()
            }
        }
        if t.count == codeCont.count {
            // Just updating
            for token in t {
                let v = codeCont.firstIndex(where: { (c) -> Bool in
                    return token.issuer == c.provider.text
                })
                
                guard let i = v else { fatalError("Could not find view with expected value \(token.issuer)") }
                let view = codeCont[i]
                view.set(provider: token.issuer, user: token.name, code: token.currentPassword!)
            }
        }

        self.progress.animateProgress(to: time)
    }    
}

class CodeView: SystemView {
    let provider: SystemLabel
    let user: SystemLabel
    let code: SystemLabel
    
    override init() {
        provider = SystemLabel()
        provider.text = "MStudios"
        
        user = SystemLabel(nil, size: 14)
        user.text = "matrixsenpai"
        
        code = SystemLabel(.right, size: 20)
        code.text = "000 000"
        
        super.init()
        
        addSubview(provider)
        addSubview(user)
        addSubview(code)
    }
    
    func set(provider p: String, user u: String, code c: String) {
        provider.text = p
        user.text = u
        code.text = c
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundColor = UIColor.flatBlack.lighten(byPercentage: 0.05)
        layer.cornerRadius = 15
        layer.borderColor = UIColor.flatWhite.cgColor
        
        provider.anchorInCorner(.topLeft, xPad: 10, yPad: 8, width: width * 0.48, height: 20)
        user.anchorInCorner(.bottomLeft, xPad: 10, yPad: 8, width: width * 0.48, height: 16)
        
        code.anchorToEdge(.right, padding: 15, width: width * 0.48, height: 22)
    }
}
