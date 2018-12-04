//
//  EurekaCellTags.swift
//  otpio
//
//  Created by Mason Phillips on 11/25/18.
//  Copyright © 2018 Matrix Studios. All rights reserved.
//

import Foundation

enum TokenCellTags: String {
    case secret   = "secretRow"
    case user     = "userRow"
    case issuer   = "issuerRow"
    case icon     = "iconRow"
    
    case cloud    = "cloudRow"
    case today    = "todayRow"
    case delete   = "deleteRow"
    
    case advanced = "advancedRow"
    case hash     = "hashRow"
    case digits   = "digitsRow"
    case interval = "intervalRow"
}

enum SettingCellTags: String {
    case theme    = "themeRow"
    case cellType = "cellTypeRow"
    
    case today    = "todayAllowedRow"
    case cloud    = "cloudAllowedRow"
}
