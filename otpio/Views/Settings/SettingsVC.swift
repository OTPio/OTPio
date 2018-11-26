//
//  SettingsVC.swift
//  otpio
//
//  Created by Mason Phillips on 11/25/18.
//  Copyright © 2018 Matrix Studios. All rights reserved.
//

import UIKit
import Eureka
import SwiftyUserDefaults

class SettingsVC: FormViewController {
    
    var cellSize: String = ""
    var theme   : Theme = ThemingEngine.sharedInstance.currentTheme
    var outlet  : DisplayVC?
    
    var rb: UIBarButtonItem {
        return UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(SettingsVC.saveSettings))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = rb
        
        form +++ Section("Theme Settings")
            <<< ActionSheetRow<String>(SettingCellTags.theme.rawValue) { row in
                row.title = "Theme"
                row.options = [
                    Theme.solarizedDark.humanReadableName(),
                    Theme.solarizedLight.humanReadableName(),
                    Theme.nightLightDark.humanReadableName(),
                    Theme.nightLightBright.humanReadableName()
                ]
                }.onChange({ (row) in
                    let v = row.value!
                    let t = Theme(rawValue: v)
                    self.theme = t
                })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.cellSize = Defaults[.cellSize]
        self.theme = ThemingEngine.sharedInstance.currentTheme
        
        if let theRow = form.rowBy(tag: SettingCellTags.theme.rawValue) as? ActionSheetRow<String> {
            theRow.value = self.theme.humanReadableName()
            theRow.updateCell()
        }
    }
    
    @objc func saveSettings() {
        ThemingEngine.sharedInstance.change(to: self.theme)

        DispatchQueue.global(qos: .background).async {
            Defaults[.currentTheme] = self.theme
            Defaults[.cellSize] = self.cellSize
        }
        
        outlet?.settingsDone()
    }
}

extension DefaultsKeys {
    static let currentTheme = DefaultsKey<Theme>("theme", defaultValue: Theme(rawValue: "solarizedDark"))
    static let cellSize     = DefaultsKey<String>("cellSize", defaultValue: "compact")
}

final class ThemeSelectorRow: Row<PushSelectorCell<Theme>>, RowType {
    required init(tag: String?) {
        super.init(tag: tag)
    }
    
    override func customDidSelect() {
        super.customDidSelect()
        
        
    }
}
