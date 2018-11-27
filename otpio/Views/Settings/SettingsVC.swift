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
    
    var cellSize: CellType = ThemingEngine.sharedInstance.currentCellType
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
            
            ThemingEngine.sharedInstance.change(to: t)
            self.changeTheme()
        })
        <<< ActionSheetRow<String>(SettingCellTags.cellType.rawValue) { row in
            row.title = "Table Style"
            row.options = ["Expanded", "Compact"]
            }.onChange({ (row) in
                let v = row.value!
                let c = CellType(rawValue: v)!
                
                self.cellSize = c
                
                ThemingEngine.sharedInstance.change(to: c)
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
        
        if let celRow = form.rowBy(tag: SettingCellTags.cellType.rawValue) as? ActionSheetRow<String> {
            celRow.value = self.cellSize.rawValue
            celRow.updateCell()
        }
        
        changeTheme()
    }
    
    func changeTheme() {
        let theme = ThemingEngine.sharedInstance
        tableView.backgroundColor = theme.background
        
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: theme.emphasizedText as Any]
        navigationController?.navigationBar.barTintColor = theme.bgHighlight
        navigationController?.navigationBar.tintColor = theme.secondaryText
        
        for row in form.allRows {
            row.baseCell.backgroundColor = theme.bgHighlight
            
            if let row = row as? ActionSheetRow<String> {
                row.cellUpdate { (cell, _) in
                    cell.textLabel?.textColor = theme.emphasizedText
                    cell.detailTextLabel?.textColor = theme.normalText
                }
            }
        }
    }
    
    @objc func saveSettings() {
        DispatchQueue.global(qos: .background).async {
            Defaults[.currentTheme] = self.theme
            Defaults[.cellSize] = self.cellSize
        }
        
        outlet?.settingsDone()
    }
}

extension DefaultsKeys {
    static let currentTheme = DefaultsKey<Theme>("theme", defaultValue: .nightLightDark)
    static let cellSize     = DefaultsKey<CellType>("cellSize", defaultValue: .compact)
}

enum CellType: String, DefaultsSerializable {
    case expanded = "Expanded"
    case compact  = "Compact"
}
