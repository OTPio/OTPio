//
//  CaptureQRCodeVC.swift
//  otpio
//
//  Created by Mason Phillips on 1/24/19.
//  Copyright © 2019 Matrix Studios. All rights reserved.
//

import UIKit
import AVFoundation
import Neon
import ChameleonFramework

class CaptureQRCodeVC: BaseUIC {
    let captureSession: AVCaptureSession = AVCaptureSession()
    var previewLayer  : AVCaptureVideoPreviewLayer?
    var qrFrame       : UIView?

    var controller: AddTokenVC?
    
    var cancelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cancelButton = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 20))
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitle("Cancel", for: .selected)
        cancelButton.setTitleColor(UIColor.flatGray, for: .normal)
        cancelButton.addTarget(self, action: #selector(CaptureQRCodeVC.cancel), for: .touchUpInside)
        
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        
        captureSession.startRunning()
        
        let deviceDiscovery = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera], mediaType: .video, position: .back)
        
        guard let device = deviceDiscovery.devices.first else {
            self.showAlert(title: "Device Error", message: "Could not find the camera!")
            return
        }
        
        let input = try? AVCaptureDeviceInput(device: device)
        captureSession.addInput(input!)
        
        let metaOutput = AVCaptureMetadataOutput()
        captureSession.addOutput(metaOutput)
        metaOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        metaOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer?.videoGravity = .resizeAspectFill
        previewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(previewLayer!)
        
        qrFrame = UIView()
        if let qrf = qrFrame {
            qrf.layer.borderColor = UIColor.flatBlue.cgColor
            qrf.layer.borderWidth = 2
            
            view.addSubview(qrf)
            view.bringSubviewToFront(qrf)
        }
        
        view.addSubview(cancelButton)
        cancelButton.anchorInCorner(.topRight, xPad: 15, yPad: 30, width: 60, height: 20)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if captureSession.isRunning == false {
            captureSession.startRunning()
        }
        
        qrFrame?.frame = .zero
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        captureSession.stopRunning()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        cancelButton.anchorInCorner(.topRight, xPad: 15, yPad: 40, width: 60, height: 20)
    }
    
    @objc func cancel() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension CaptureQRCodeVC: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.count == 0 {
            qrFrame?.frame = .zero
            return
        }
        
        let code = metadataObjects.first! as! AVMetadataMachineReadableCodeObject
        
        if code.type == .qr {
            let bcObject = previewLayer?.transformedMetadataObject(for: code)
            qrFrame?.frame = bcObject!.bounds
            
            guard
                let url = code.stringValue,
                let tokenUrl = URLComponents(string: url)
            else { return }
            
            if tokenUrl.scheme == "otpauth" {
                controller?.doneScanning(with: tokenUrl.url!)
            }
        }
    }
}
