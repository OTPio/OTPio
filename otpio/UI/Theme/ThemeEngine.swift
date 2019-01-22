//
//  ThemeEngine.swift
//  otpio
//
//  Created by Mason Phillips on 1/11/19.
//  Copyright © 2019 Matrix Studios. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

class ThemeEngine {
    static let sharedInstance: ThemeEngine = ThemeEngine()
    
    var currentTheme: Theme = Defaults[.theme]
    
    init() {
        set(theme: currentTheme)
    }
    
    func set(theme t: Theme) {
        self.currentTheme = t
        
        NotificationCenter.default.post(name: .themeDidChange, object: t)
        
        let colors = t.colorsForTheme()
        var attributes: Dictionary<NSAttributedString.Key, Any> = [:]
        
        attributes[.foregroundColor] = colors.emphasizedText
        UINavigationBar.appearance().barTintColor = colors.backgroundColor
        UINavigationBar.appearance().tintColor = colors.offsetBackground
        UINavigationBar.appearance().titleTextAttributes = attributes
        
        UIBarButtonItem.appearance().tintColor = colors.normalText
        
        BaseUIL.appearance().backgroundColor = .clear
    }
}
