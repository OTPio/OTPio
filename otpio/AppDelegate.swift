//
//  AppDelegate.swift
//  otpio
//
//  Created by Mason Phillips on 2/10/19.
//  Copyright © 2019 Matrix Studios. All rights reserved.
//

import UIKit
import MMDrawerController
import Swinject

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var assembler: Assembler!
    var window   : UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        assembler = Assembler([AppAssembly()])

        let router = assembler.resolver.resolve(RouterInterface.self)!
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = router.menuInterface
        window?.makeKeyAndVisible()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {

    }

    func applicationDidEnterBackground(_ application: UIApplication) {

    }

    func applicationWillEnterForeground(_ application: UIApplication) {

    }

    func applicationDidBecomeActive(_ application: UIApplication) {

    }

    func applicationWillTerminate(_ application: UIApplication) {

    }
}

extension UIApplicationDelegate {
    static var appDelegate: AppDelegate {
        return UIApplication.shared.delegate! as! AppDelegate
    }
}
