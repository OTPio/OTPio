//
//  ConfirmQRCodeVC.swift
//  otpio
//
//  Created by Mason Phillips on 11/13/18.
//  Copyright © 2018 Matrix Studios. All rights reserved.
//

import UIKit
import libtoken
import Neon

class ConfirmQRCodeVC: SystemViewController {
    
    var outlet: AddQRCodePageController?
    var token: Token!
    
    var t: Timer?
    
    let tokenDisplay: SystemLabel
    let timeDisplay : SystemLabel
    
    let descriptionLabel: SystemLabel
    
    var rightBar: UIBarButtonItem {
        let b = UIBarButtonItem(title: "Done", style: .plain, target: outlet, action: #selector(AddQRCodePageController.done))
        return b
    }

    override init() {
        tokenDisplay = SystemLabel(.center, size: 32)
        tokenDisplay.font = UIFont(name: "SourceCodePro-ExtraLight", size: 40)
        timeDisplay  = SystemLabel(.center, size: 20)
        timeDisplay.font = UIFont(name: "SourceCodePro-ExtraLight", size: 20)
        
        descriptionLabel = SystemLabel(.center)
        descriptionLabel.multiline()
        descriptionLabel.text = fetchString(forKey: "token-confirmation")
        
        super.init()
        
        tokenDisplay.text = "Loading..."
        
        view.addSubview(tokenDisplay)
        view.addSubview(timeDisplay)
        view.addSubview(descriptionLabel)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let theme = ThemingEngine.sharedInstance
        
        view.backgroundColor = theme.background
        tokenDisplay.textColor = theme.emphasizedText
        timeDisplay.textColor = theme.secondaryText
        descriptionLabel.textColor = theme.normalText
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        outlet?.navigationItem.title = "Confirm Code"
        outlet?.navigationItem.rightBarButtonItem = rightBar
        
        self.token = outlet?.token

        self.t = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (t) in
            let p = self.token.password(format: true)
            let r = self.token.timeRemaining(true)
            
            DispatchQueue.main.async {
                self.tokenDisplay.text = p
                self.timeDisplay.text  = "Valid for \(Int(r))s"
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        t?.invalidate()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tokenDisplay.anchorAndFillEdge(.top, xPad: 20, yPad: view.height * 0.2, otherSize: 40)
        timeDisplay.alignAndFillWidth(align: .underCentered, relativeTo: tokenDisplay, padding: 15, height: 24)
        
        descriptionLabel.anchorAndFillEdge(.bottom, xPad: 20, yPad: 15, otherSize: view.height * 0.45)
    }
}
