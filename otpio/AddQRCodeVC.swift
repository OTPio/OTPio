//
//  AddQRCodeVC.swift
//  otpio
//
//  Created by Mason Phillips on 11/12/18.
//  Copyright © 2018 Matrix Studios. All rights reserved.
//

import UIKit
import AVFoundation

class AddQRCodeVC: SystemViewController {

    var outlet: AddQRCodePageController?
    
    var captureSession: AVCaptureSession = AVCaptureSession()
    var previewLayer: AVCaptureVideoPreviewLayer?
    var qrFrame: SystemView?
        
    override init() {
        super.init()
        
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .flatBlack
        
        captureSession.startRunning()
        outlet?.navigationItem.title = "Scan 2FA Token"
        outlet?.navigationItem.rightBarButtonItem = nil
        
        let deviceDiscovery = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera], mediaType: .video, position: .back)
        
        do {
            guard let capture = deviceDiscovery.devices.first else {
                throw InitCaptureError.getCamera
            }
            
            let input = try AVCaptureDeviceInput(device: capture)
            captureSession.addInput(input)
            
            let metaOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(metaOutput)
            
            metaOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metaOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        } catch let e {
            print(e.localizedDescription)
        }

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer?.videoGravity = .resizeAspectFill
        previewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(previewLayer!)
        
        captureSession.startRunning()
        
        qrFrame = SystemView()
        if let qrFrame = qrFrame {
            qrFrame.layer.borderColor = UIColor.flatGreen.cgColor
            qrFrame.layer.borderWidth = 2
            view.addSubview(qrFrame)
            view.bringSubviewToFront(qrFrame)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        captureSession.stopRunning()
    }
}

extension AddQRCodeVC: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.count == 0 {
            qrFrame?.frame = CGRect.zero
            return
        }
        
        let obj = metadataObjects.first! as! AVMetadataMachineReadableCodeObject
        
        if obj.type == .qr {
            let bcObject = previewLayer?.transformedMetadataObject(for: obj)
            qrFrame?.frame = bcObject!.bounds
            
            if obj.stringValue != nil {
                captureSession.stopRunning()
                self.outlet?.doneScanning(with: obj.stringValue!)
            }
        }
    }
}

enum InitCaptureError: Error {
    case getCamera, setupCamera
}
