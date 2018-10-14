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
    
    let icon: UIImageView
    let issuerLabel: SystemLabel
    let userLabel: SystemLabel
    
    override init() {
        icon = UIImageView()
        icon.image = UIImage.fontAwesomeIcon(name: .github, style: .brands, textColor: .flatWhite, size: CGSize(width: 28, height: 28))
        
        issuerLabel = SystemLabel()
        issuerLabel.font = UIFont.boldSystemFont(ofSize: 22)
        issuerLabel.text = "GitHub"
        
        userLabel = SystemLabel()
        userLabel.font = UIFont.italicSystemFont(ofSize: 14)
        userLabel.text = "MatrixSenpai"
        
        super.init()
        
        view.addSubview(icon)
        view.addSubview(issuerLabel)
        view.addSubview(userLabel)
    }
    
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
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        icon.anchorInCorner(.topLeft, xPad: 15, yPad: 100, width: 100, height: 100)
        issuerLabel.alignAndFillWidth(align: .toTheRightCentered, relativeTo: icon, padding: 15, height: 24)
        userLabel.align(.underCentered, relativeTo: issuerLabel, padding: 5, width: issuerLabel.width, height: 16)
    }
    
    func configure(with t: Token) {
        self.token = t
        
        navigationItem.title = t.issuer
        
        issuerLabel.text = t.issuer
        userLabel.text = t.name
        
        let image = t.iconForToken()
        icon.image = image
    }
}
