//
//  QRCodeDetailsVC.swift
//  otpio
//
//  Created by Mason Phillips on 11/13/18.
//  Copyright © 2018 Matrix Studios. All rights reserved.
//

import UIKit
import libtoken
import Eureka
import Base32
import libfa

class QRCodeDetailsVC: FormViewController {
    var outlet: AddQRCodePageController?
    var token: Token!
    
    var provider: TokenForm = TokenForm.sharedInstance
    
    var rightBar: UIBarButtonItem {
        let b = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(QRCodeDetailsVC.saveData))
        return b
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.backgroundColor = .flatBlack
        
        self.form = provider.form
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        outlet?.navigationItem.title = "Token Details"
        outlet?.navigationItem.rightBarButtonItem = rightBar
        
        provider.themeForm()
        
        guard let t = outlet?.token else { return }
        self.token = t
        provider.configure(with: t)
    }
    
    @objc func saveData() {
        outlet?.token = provider.getToken()
        outlet?.confirmCode()
    }
}
