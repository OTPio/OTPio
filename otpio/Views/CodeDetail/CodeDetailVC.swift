//
//  CodeDetailVC.swift
//  otpio
//
//  Created by Mason Phillips on 11/14/18.
//  Copyright © 2018 Matrix Studios. All rights reserved.
//

import UIKit
import Eureka
import libtoken
import libfa
import Base32
import SCLAlertView

class CodeDetailVC: FormViewController {

    var token: Token?
    
    var isInToday: Bool?
    var isInCloud: Bool?
    
    override var previewActionItems: [UIPreviewActionItem] {
        let delete = UIPreviewAction(title: "Delete Token", style: .destructive) { (action, controller) in
            SystemCommunicator.sharedInstance.remove(token: self.token!)
        }
        
        guard let t = token else { return [delete] }
        
        let td = SystemCommunicator.sharedInstance.isInToday(token: t)
        let cd = SystemCommunicator.sharedInstance.isInCloud(token: t)
        
        let tt = (td) ? "Remove from":"Add to"
        let ct = (cd) ? "Remove from":"Add to"
        
        let today = UIPreviewAction(title: "\(tt) Today Widget", style: .default) { (_, _) in
            SystemCommunicator.sharedInstance.today(token: t, available: !td)
        }
        
        let cloud = UIPreviewAction(title: "\(ct) iCloud (Sync)", style: .default) { (_, _) in
            SystemCommunicator.sharedInstance.cloud(token: t, available: !cd)
        }
        
        return [today, cloud, delete]
    }
    
    var provider: TokenForm = TokenForm.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        form = provider.form
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let theme = ThemingEngine.sharedInstance
        super.viewWillAppear(animated)
        tableView.backgroundColor = theme.background
        
        let b = UIBarButtonItem(title: String.fontAwesomeIcon(name: .trashAlt), style: .plain, target: self, action: #selector(CodeDetailVC.deleteToken))
        b.setTitleTextAttributes([.foregroundColor: theme.secondaryText, .font: FAREGULAR_UIFONT], for: .normal)
        b.setTitleTextAttributes([.foregroundColor: theme.emphasizedText, .font: FAREGULAR_UIFONT], for: .highlighted)
        navigationItem.rightBarButtonItem = b
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        SystemCommunicator.sharedInstance.update()
    }
    
    func configure(with t: Token) {
        self.token = t
        provider.configure(with: t, allowSaves: true)
        
        navigationItem.title = t.issuer
    }
    
    @objc func deleteToken() {
        let alert = SCLAlertView()
        alert.addButton("I'm Sure!", action: {
            SystemCommunicator.sharedInstance.remove(token: self.token!)
            self.navigationController?.popToRootViewController(animated: true)
        })
        
        alert.showError("Delete \(self.token!.issuer)", subTitle: fetchString(forKey: "delete-token"), closeButtonTitle: "Keep It!")
    }
}

