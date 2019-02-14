//
//  AddQRController.swift
//  otpio
//
//  Created by Mason Phillips on 2/13/19.
//  Copyright © 2019 Matrix Studios. All rights reserved.
//

import UIKit
import arek
import Eureka

class AddTokenController: ParentBaseViewController {
    let formView: UIView = UIView(frame: .zero)
    var qrButton: UIBarButtonItem {
        let b = UIBarButtonItem(title: String.fontAwesomeIcon(name: .cameraRetro), style: .plain, target: self, action: #selector(AddTokenController.showCamera))
        let attrs: [NSAttributedString.Key: Any] = [.font: UIFont.fontAwesome(ofSize: 18, style: .regular)]
        b.setTitleTextAttributes(attrs, for: .normal)
        b.setTitleTextAttributes(attrs, for: .highlighted)
        return b
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let cameraPermissions: ArekCamera = ArekCamera()
        cameraPermissions.manage { [unowned self] (status) in
            DispatchQueue.main.async {
                switch status {
                case .authorized: self.navigationItem.rightBarButtonItem = self.qrButton
                default: return
                }
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    @objc func showCamera() {
        
    }
}
