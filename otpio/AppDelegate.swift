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
    var root: DisplayViewController
    
    override init() {
        FontBlaster.blast()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        root = DisplayViewController()
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let shortcut = UIApplicationShortcutItem(type: "ScanCode", localizedTitle: "Scan Barcode", localizedSubtitle: "Scan a code for adding", icon: UIApplicationShortcutIcon(type: .add), userInfo: nil)
        
        Chameleon.setGlobalThemeUsingPrimaryColor(.flatBlack, withSecondaryColor: .flatBlackDark, andContentStyle: .light)
        
        UIApplication.shared.shortcutItems = [shortcut]
        System.sharedInstance.fetchFromCloud()
        
        let nav = UINavigationController(rootViewController: root)
        window?.rootViewController = nav
        
        window?.makeKeyAndVisible()
        
        return true
    }
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        root.shouldScan = true
        root.viewDidAppear(false)
        completionHandler(true)
    }

    func applicationWillResignActive(_ application: UIApplication) {
        System.sharedInstance.stopAllTimers()
        System.sharedInstance.uploadToCloud()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        System.sharedInstance.restartTimers()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        System.sharedInstance.restartTimers()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

