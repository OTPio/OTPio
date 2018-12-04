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
        
        navigationItem.title = "App Settings"
        
        tableView.tableFooterView = {
            let f = SystemView(frame: CGRect(x: 0, y: 0, width: view.width, height: 20))
            
            let l = SystemLabel(.center, size: 15)
            l.textColor = UIColor.flatGray.withAlphaComponent(0.6)
            
            let version = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String
            let build = Bundle.main.infoDictionary!["CFBundleVersion"] as? String
            
            l.text = "OTP.io v\(version!)-\(build!)"
            
            f.addSubview(l)
            l.fillSuperview()
            return f
        }()
        
        navigationItem.rightBarButtonItem = rb
        
        form +++ Section("Theme Settings")
        <<< ThemeRow(SettingCellTags.theme.rawValue) { row in
            row.title = "Theme"
            row.value = Defaults[.currentTheme]
        }.onChange({ (row) in
            guard let value = row.value else { return }
            self.theme = value
            ThemingEngine.sharedInstance.change(to: value)
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
        
//        +++ Section("In-App Privacy")
//        <<< SwitchRow(SettingCellTags.today.rawValue) { row in
//            row.title = "Allow Save in Today View"
//            row.value = Defaults[.allowsToday]
//        }.onChange({ (row) in
//            guard let value = row.value else { return }
//            Defaults[.allowsToday] = value
//        })
//        <<< SwitchRow(SettingCellTags.cloud.rawValue) { row in
//            row.title = "Allow Save to Cloud"
//            row.value = Defaults[.allowsCloud]
//        }.onChange({ (row) in
//            guard let value = row.value else { return }
//            Defaults[.allowsCloud] = value
//        })
//
//        +++ Section("Testing")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.cellSize = Defaults[.cellSize]
        self.theme = ThemingEngine.sharedInstance.currentTheme
        
        if let celRow = form.rowBy(tag: SettingCellTags.cellType.rawValue) as? ActionSheetRow<String> {
            celRow.value = self.cellSize.rawValue
            celRow.updateCell()
        }
        
        if let row = form.rowBy(tag: SettingCellTags.cloud.rawValue) as? SwitchRow {
            row.updateCell()
        }
        
        if let row = form.rowBy(tag: SettingCellTags.today.rawValue) as? SwitchRow {
            row.updateCell()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let theme = ThemingEngine.sharedInstance
        
        tableView.backgroundColor = theme.background
        
        for row in self.form.allRows {
            row.baseCell.backgroundColor = theme.bgHighlight
            
            if let row = row as? ActionSheetRow<String> {
                row.cellUpdate { (cell, _) in
                    cell.textLabel?.textColor = theme.emphasizedText
                    cell.detailTextLabel?.textColor = theme.normalText
                }
            }
            
            if let row = row as? IconRow {
                row.cellUpdate { (_, row) in
                    row.theme()
                }
            }
            
            if let row = row as? ThemeRow {
                row.cellUpdate { (_, row) in
                    row.theme()
                }
            }
            
            if let row = row as? SwitchRow {
                row.cellUpdate { (cell, _) in
                    cell.backgroundColor = theme.bgHighlight
                    cell.textLabel?.textColor = theme.emphasizedText
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

enum CellType: String, DefaultsSerializable {
    case expanded = "Expanded"
    case compact  = "Compact"
}
