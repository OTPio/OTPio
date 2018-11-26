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
        
        let today = UIPreviewAction(title: "\(tt) Today Widget", style: .default) { (action, controller) in
            if td { SystemCommunicator.sharedInstance.removeFromToday(token: t) }
            else { SystemCommunicator.sharedInstance.sendToToday(token: t) }
        }
        
        let cloud = UIPreviewAction(title: "\(ct) iCloud (Sync)", style: .default) { (action, controller) in
            if cd { SystemCommunicator.sharedInstance.removeFromCloud(token: t) }
            else { SystemCommunicator.sharedInstance.sendToCloud(token: t) }
        }
        
        return [today, cloud, delete]
    }
    
    var provider: TokenForm = TokenForm.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        form = provider.form
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.backgroundColor = ThemingEngine.sharedInstance.background
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        SystemCommunicator.sharedInstance.update()
    }
    
    func configure(with t: Token) {
        self.token = t
        provider.configure(with: t)
        
        navigationItem.title = t.issuer
    }
}

