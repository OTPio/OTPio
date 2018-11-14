//
//  DisplayVC.swift
//  otpio
//
//  Created by Mason Phillips on 11/12/18.
//  Copyright © 2018 Matrix Studios. All rights reserved.
//

import UIKit
import libfa

class DisplayVC: SystemViewController {

    var rightBar: UIBarButtonItem {
        let b = UIBarButtonItem(title: String.fontAwesomeIcon(name: .qrcode), style: .plain, target: self, action: #selector(DisplayVC.showQR(sender:)))
        b.setTitleTextAttributes(FAREGULAR_ATTR, for: .normal)
        b.setTitleTextAttributes(FAREGULAR_ATTR, for: .highlighted)

        return b
    }
    
    override init() {
        
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .flatBlack
        
        navigationItem.title = "My Codes"
        navigationItem.rightBarButtonItem = rightBar
    }
    
    @objc func showQR(sender: UIBarButtonItem) {
        let controller = AddQRCodePageController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        navigationController?.pushViewController(controller, animated: true)
    }
}
