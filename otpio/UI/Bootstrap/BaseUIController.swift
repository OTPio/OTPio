//
//  BaseUIController.swift
//  otpio
//
//  Created by Mason Phillips on 1/11/19.
//  Copyright © 2019 Matrix Studios. All rights reserved.
//

import UIKit
import MMDrawerController

class BaseUIC: UIViewController {
    
    var leftButton: MMDrawerBarButtonItem {
        return MMDrawerBarButtonItem(target: self, action: #selector(BaseUIC.openMenu))
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(BaseUIC.theme(with:)), name: .themeDidChange, object: ThemeEngine.self)
        theme(with: ThemeEngine.sharedInstance.currentTheme)
        
        setNeedsStatusBarAppearanceUpdate()
        navigationItem.leftBarButtonItem = leftButton
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    @objc func theme(with t: Any) {
        guard let theme = t as? Theme else {
            fatalError("Could not cast back to theme")
        }
        
        let colors = theme.colorsForTheme()
        view.backgroundColor = colors.backgroundColor
    }
    
    @objc func openMenu() {
        guard mm_drawerController.openSide != .left else {
            mm_drawerController.closeDrawer(animated: true, completion: nil)
            return
        }
        mm_drawerController.open(.left, animated: true, completion: nil)
    }
}
