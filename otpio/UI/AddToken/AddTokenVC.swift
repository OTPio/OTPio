//
//  AddTokenVC.swift
//  otpio
//
//  Created by Mason Phillips on 1/23/19.
//  Copyright © 2019 Matrix Studios. All rights reserved.
//

import UIKit
import arek
import PMAlertController

class AddTokenVC: BaseUIC {
    
    var canUseCamera: Bool = false {
        didSet {
            if self.canUseCamera {
                self.navigationItem.rightBarButtonItem = button
            }
        }
    }

    lazy var cameraView: CaptureQRCodeVC = CaptureQRCodeVC()
    
    var button: UIBarButtonItem {
        let b = UIBarButtonItem(title: "\u{f030}", style: .plain, target: self, action: #selector(AddTokenVC.showCaptureWindow))
        b.setTitleTextAttributes([.font: Font(font: FontFamily.FontAwesome5Pro.regular, size: 20)], for: .normal)
        b.setTitleTextAttributes([.font: Font(font: FontFamily.FontAwesome5Pro.regular, size: 20)], for: .selected)
        return b
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cameraPermissions = ArekCamera()
        cameraPermissions.manage { (status) in
            switch status {
            case .authorized: self.canUseCamera = true
            default: self.canUseCamera = false
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    @objc func showCaptureWindow() {
        if cameraView.controller == nil {
            cameraView.controller = self
        }
        self.present(cameraView, animated: true, completion: nil)
    }
    
    func doneScanning(with: URL) {
        if cameraView.isBeingPresented {
            cameraView.dismiss(animated: true, completion: nil)
        }
    }
}

extension AddTokenVC {
    func processInitialData() {
        if UIPasteboard.general.hasURLs {
            guard let urls = UIPasteboard.general.urls else {
                return
            }
            
            for u in urls {
                guard let components = URLComponents(url: u, resolvingAgainstBaseURL: false) else { continue }
                if components.scheme == "otpauth" {
                    let alert = PMAlertController(title: "Token Found!", description: fetchString(forKey: "found_url"), image: nil, style: .alert)
                    alert.addAction(PMAlertAction(title: "Use It", style: .default, action: {
                        self.doneScanning(with: u)
                    }))
                    alert.addAction(PMAlertAction(title: "Don't", style: .cancel, action: {
                        alert.dismiss(animated: true, completion: nil)
                    }))
                    
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
}
