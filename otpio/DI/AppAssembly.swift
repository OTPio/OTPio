//
//  AppAssembly.swift
//  otpio
//
//  Created by Mason Phillips on 2/11/19.
//  Copyright © 2019 Matrix Studios. All rights reserved.
//

import Foundation
import Swinject

class AppAssembly: Assembly {
    func assemble(container: Container) {
        container.register(ThemeManager.self) { _ in
            return ThemeManager(AppDelegate.appDelegate.assembler)
        }.inObjectScope(ObjectScope.container)
        
        container.register(RouterInterface.self) { _ in
            return Router(AppDelegate.appDelegate.assembler)
        }.inObjectScope(ObjectScope.container)
        
        container.register(HomeModelType.self) { _ in
            return HomeModel(AppDelegate.appDelegate.assembler)
        }.inObjectScope(ObjectScope.container)
    
        container.register(AddTokenModelType.self) { _ in
            return AddTokenModel(AppDelegate.appDelegate.assembler)
        }.inObjectScope(ObjectScope.container)
    }
}
