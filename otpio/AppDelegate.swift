//
//  AppDelegate.swift
//  otpio
//
//  Created by Mason Phillips on 10/8/18.
//  Copyright © 2018 Matrix Studios. All rights reserved.
//

import UIKit
import FontBlaster
import ChameleonFramework
import Fabric
import Crashlytics
import libtoken

// Global Font Awesome declarations
let FALIGHT_UIFONT  : UIFont = UIFont(name: "FontAwesome5ProLight", size: 20)!
let FAREGULAR_UIFONT: UIFont = UIFont(name: "FontAwesome5ProRegular", size: 20)!
let FASOLID_UIFONT  : UIFont = UIFont(name: "FontAwesome5ProSolid", size: 20)!
let FABRANDS_UIFONT : UIFont = UIFont(name: "FontAwesome5BrandsRegular", size: 20)!

let SOURCECODE      : UIFont = UIFont(name: "SourceCodeVariable-Roman", size: 20)!

let FALIGHT_ATTR     = [NSAttributedString.Key.font: FALIGHT_UIFONT]
let FAREGULAR_ATTR   = [NSAttributedString.Key.font: FAREGULAR_UIFONT]
let FASOLID_ATTR     = [NSAttributedString.Key.font: FASOLID_UIFONT]
let FABRANDS_ATTR    = [NSAttributedString.Key.font: FABRANDS_UIFONT]

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var root: DisplayVC
    
    override init() {
        FontBlaster.blast()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        root = DisplayVC()
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        ThemingEngine.sharedInstance.change(to: .compact)
        ThemingEngine.sharedInstance.change(to: .nightLightDark)
        let nav = UINavigationController(rootViewController: root)
        nav.navigationBar.barTintColor = .flatBlack
        window?.rootViewController = nav
        
        window?.makeKeyAndVisible()
        
        Fabric.with([Crashlytics.self])
        
        if CommandLine.arguments.count > 0 {
            guard
                let token = CommandLine.arguments.last,
                let url   = URL(string: token),
                let t     = Token(from: url)
            else { return true }
            
            SystemCommunicator.sharedInstance.addTemp(token: t)
        }
        
        return true
    }
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        
    }

    func applicationWillResignActive(_ application: UIApplication) {
        SystemCommunicator.sharedInstance.stopTimer()
        SystemCommunicator.sharedInstance.updateKeychain()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        SystemCommunicator.sharedInstance.restartTimer()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        SystemCommunicator.sharedInstance.updateKeychain()
    }
}

