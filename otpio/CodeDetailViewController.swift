//
//  CodeDetailViewController.swift
//  otpio
//
//  Created by Mason Phillips on 10/13/18.
//  Copyright © 2018 Matrix Studios. All rights reserved.
//

import UIKit
import OneTimePassword

class CodeDetailViewController: SystemViewController {

    var token: Token?
    
    override var previewActionItems: [UIPreviewActionItem] {
        let delete: UIPreviewActionItem = UIPreviewAction(title: "Delete", style: .destructive) { (action, controller) in
            print("Delete Code")
        }
        
        return [delete]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .flatBlackDark
    }
    
    func configure(with t: Token) {
        self.token = t
        
        navigationItem.title = t.issuer
    }
}
