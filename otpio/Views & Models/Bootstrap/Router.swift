//
//  Router.swift
//  otpio
//
//  Created by Mason Phillips on 2/13/19.
//  Copyright © 2019 Matrix Studios. All rights reserved.
//

import Foundation
import LibFA
import RxSwift
import RxCocoa
import Swinject
import MMDrawerController

class Router {
    private let assembler      : Assembler
    
    private let menuController : MenuController
    private let menuHandler    : MMDrawerController
    private var viewControllers: [NavigationOption: UINavigationController]
    
    internal var currentOption  : NavigationOption
    
    init(_ assembler: Assembler) {
        self.assembler = assembler
        
        currentOption = .default
        
        menuController = MenuController()
        let dController = currentOption.controller
        let mController = UINavigationController(rootViewController: dController)
        menuHandler = MMDrawerController(center: mController, leftDrawerViewController: menuController)
        menuHandler.openDrawerGestureModeMask = .all
        menuHandler.closeDrawerGestureModeMask = .all
        viewControllers = [currentOption: mController]
    }
    
    func move(to option: NavigationOption) {
        guard option != currentOption else { return }
        currentOption = option

        let controller: UINavigationController
        if let c = viewControllers[option] {
            controller = c
        } else {
            let c = UINavigationController(rootViewController: option.controller)
            viewControllers[option] = c
            controller = c
        }
        
        menuHandler.setCenterView(controller, withCloseAnimation: true, completion: nil)
    }
}

protocol RouterInterface {
    var menuInterface: MMDrawerController { get }
    var currentOption: NavigationOption { get }
    func move(to option: NavigationOption)
}
extension Router: RouterInterface {
    var menuInterface: MMDrawerController {
        return menuHandler
    }
}

enum NavigationOption: Int, CaseIterable {
    static let `default`: NavigationOption = .home
    case home     = 0
    case add      = 1
    case settings = 2
    
    var controller: ParentBaseViewController {
        switch self {
        case .home    : return HomeController()
        case .add     : return AddTokenController()
        case .settings: return ParentBaseViewController()
        }
    }
    var title     : String {
        switch self {
        case .home    : return "Home"
        case .add     : return "Add QR Code"
        case .settings: return "Settings"
        }
    }
    var icon      : FontAwesome {
        switch self {
        case .home    : return .qrcode
        case .add     : return .layerPlus
        case .settings: return .cogs
        }
    }
}
