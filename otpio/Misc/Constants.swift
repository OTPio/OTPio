//
//  Constants.swift
//  otpio
//
//  Created by Mason Phillips on 1/11/19.
//  Copyright © 2019 Matrix Studios. All rights reserved.
//

import Foundation
import SwiftyUserDefaults
import LibFA

struct Constants {
    enum CellIdentifiers: String {
        case menu = "menuCell"
    }
    
    enum TokenCellTags: String {
        case camera   = "showCamera"
        
        case secret   = "secret"
        case user     = "user"
        case issuer   = "issuer"
        case icon     = "icon"
        
        case advanced = "advanced"
        case hash     = "hash"
        case digits   = "digits"
        case interval = "interval"
        
        case cloud    = "cloudAvailable"
        case today    = "todayAvailable"
        
        var rowTitle: String {
            switch self {
            case .user, .issuer, .digits, .interval:
                return self.rawValue.capitalized
            case .secret:
                return "Token Secret"
            case .icon:
                return "Selected Icon"
            case .advanced:
                return "Show Advanced Details"
            case .hash:
                return "Hash Used"
            case .cloud:
                return "Available in iCloud"
            case .today:
                return "Available in Today View"
            case .camera:
                return "Tap to scan QR Code"
            }
        }
    }
    
    enum TokenSectionTags: String {
        case general      = "general"
        case advanced     = "advanced"
        case available    = "available"
        case initialToken = "initial"
    }
    
    enum RowItemIcon {
        case incrementEnabled
        case incrementDisabled
        case decrementEnabled
        case decrementDisabled
        
        var image: UIImage {
            let theme = ThemeEngine.sharedInstance.currentTheme.colorsForTheme()
            let icon: FontAwesome
            let color: Color
            switch self {
            case .incrementEnabled :
                icon = .plus
                color = theme.emphasizedText
            case .incrementDisabled:
                icon = .plus
                color = theme.secondaryText.withAlphaComponent(0.4)
            case .decrementEnabled:
                icon = .minus
                color = theme.emphasizedText
            case .decrementDisabled:
                icon = .minus
                color = theme.secondaryText.withAlphaComponent(0.4)
            }
            
            return  UIImage.fontAwesomeIcon(name: icon, style: .regular, textColor: color, size: CGSize(width: 20, height: 20))
        }
    }
}

extension Notification.Name {
    static var themeDidChange = Notification.Name("themeDidChange")
}

extension DefaultsKeys {
    static var theme: DefaultsKey = DefaultsKey<Theme>("theme", defaultValue: .nightLightDark)
}
