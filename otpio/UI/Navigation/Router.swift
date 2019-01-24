//
//  Router.swift
//  otpio
//
//  Created by Mason Phillips on 1/23/19.
//  Copyright © 2019 Matrix Studios. All rights reserved.
//

import Foundation
import MMDrawerController

class Router {
    public static let sharedInstance: Router = Router()
    
    private(set) var currentOption: RouterOption
    
    public  let menuController: MMDrawerController
    private let menu          : MenuController
    private var controllers   : [RouterOption: BaseUINavController]
    
    init() {
        currentOption = .default
        
        let controller = currentOption.controllerForOption()
        let nav = BaseUINavController(rootViewController: controller)
        
        controllers = [currentOption: nav]
        
        menu = MenuController()
        let menuNav = BaseUINavController(rootViewController: menu)
        menuNav.navigationBar.isHidden = true
        
        menuController = MMDrawerController(center: nav, leftDrawerViewController: menuNav)
        menuController.openDrawerGestureModeMask = .all
        menuController.closeDrawerGestureModeMask = .all
        menuController.maximumLeftDrawerWidth = 200
    }
    
    func `switch`(to option: RouterOption) {
        guard let navc = controllers[option] else {
            let newController = option.controllerForOption()
            let navController = BaseUINavController(rootViewController: newController)
            
            menuController.setCenterView(navController, withCloseAnimation: true, completion: nil)
            controllers[option] = navController
            return
        }
        
        menuController.setCenterView(navc, withCloseAnimation: true, completion: nil)
    }
}
