//
//  Theme.swift
//  otpio
//
//  Created by Mason Phillips on 11/20/18.
//  Copyright © 2018 Matrix Studios. All rights reserved.
//

import Foundation
import ChameleonFramework
import SwiftyUserDefaults

enum Theme: String, DefaultsSerializable {
    
    case solarizedLight   = "solarizedLight"
    case solarizedDark    = "solarizedDark"
    case nightLightDark   = "nightLightDark"
    case nightLightBright = "nightLightBright"
    
    init(rawValue v: String) {
        switch v {
        case "solarizedLight",
             "Solarized Light"   : self = .solarizedLight
        case "solarizedDark",
             "Solarized Dark"    : self = .solarizedDark
        case "nightLightDark",
             "Night/Light Dark"  : self = .nightLightDark
        case "nightLightBright",
             "Night/Light Bright": self = .nightLightBright
        default: self = .solarizedDark
        }
    }
    
    public static let allThemes: Array<Theme> = [
        .solarizedDark , .solarizedLight,
        .nightLightDark, .nightLightBright
    ]
    
    func humanReadableName() -> String {
        switch self {
        case .solarizedDark   : return "Solarized Dark"
        case .solarizedLight  : return "Solarized Light"
        case .nightLightDark  : return "Night/Light Dark"
        case .nightLightBright: return "Night/Light Bright"
        }
    }
    
    internal func colorsForTheme() -> Dictionary<ThemePart, UIColor> {
        switch self {
        case .solarizedDark:
            return [
                .background    : ColorName.solarizedBase03.color,
                .bgHighlight   : ColorName.solarizedBase02.color,
                .normalText    : ColorName.solarizedBase0.color,
                .secondaryText : ColorName.solarizedBase01.color,
                .emphasizedText: ColorName.solarizedBase1.color,
                .progressTrack : ColorName.solarizedBlue.color.withAlphaComponent(0.6),
                .border        : ColorName.solarizedCyan.color.withAlphaComponent(0.5)
            ]
            
        case .solarizedLight:
            return [
                .background    : ColorName.solarizedBase3.color,
                .bgHighlight   : ColorName.solarizedBase2.color,
                .normalText    : ColorName.solarizedBase00.color,
                .secondaryText : ColorName.solarizedBase1.color,
                .emphasizedText: ColorName.solarizedBase01.color,
                .progressTrack : ColorName.solarizedYellow.color.withAlphaComponent(0.6),
                .border        : ColorName.solarizedCyan.color.withAlphaComponent(0.5)
            ]
        case .nightLightDark:
            return  [
                .background    : ColorName.nightlightBlackDark.color,
                .bgHighlight   : ColorName.nightlightBlack.color,
                .normalText    : ColorName.nightlightWhiteDark.color,
                .secondaryText : ColorName.nightlightGray.color,
                .emphasizedText: ColorName.nightlightWhite.color,
                .progressTrack : ColorName.nightlightBlue.color.withAlphaComponent(0.6),
                .border        : ColorName.nightlightBlue.color
            ]
        case .nightLightBright:
            return [
                .background    : ColorName.nightlightWhite.color,
                .bgHighlight   : ColorName.nightlightWhiteDark.color,
                .normalText    : ColorName.nightlightBlack.color,
                .secondaryText : ColorName.nightlightGrayDark.color,
                .emphasizedText: ColorName.nightlightBlackDark.color,
                .progressTrack : ColorName.nightlightBlue.color.withAlphaComponent(0.6),
                .border        : ColorName.nightlightBlue.color
            ]
        }
    }
}

enum ThemePart {
    case background, bgHighlight
    case normalText, secondaryText, emphasizedText
    case border, progressTrack
}

class ThemingEngine {
    static let sharedInstance: ThemingEngine = ThemingEngine()
    
    var currentTheme   : Theme
    var currentCellType: CellType
    
    var background    : UIColor!
    var bgHighlight   : UIColor!
    var normalText    : UIColor!
    var secondaryText : UIColor!
    var emphasizedText: UIColor!
    var progressTrack : UIColor!
    var border        : UIColor!
    
    init() {
        currentTheme = Defaults[.currentTheme]
        currentCellType = Defaults[.cellSize]
        
        setup()
    }
    
    func change(to t: Theme) {
        currentTheme = t
        
        setup()
    }
    
    func change(to c: CellType) {
        currentCellType = c
        Defaults[.cellSize] = c
    }
    
    private func setup() {
        let colors = currentTheme.colorsForTheme()
        
        background = colors[.background]
        bgHighlight = colors[.bgHighlight]
        normalText = colors[.normalText]
        secondaryText = colors[.secondaryText]
        emphasizedText = colors[.emphasizedText]
        progressTrack = colors[.progressTrack]
        border = colors[.border]
        
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: colors[.emphasizedText] as Any]
        UINavigationBar.appearance().barTintColor = colors[.bgHighlight]
        UINavigationBar.appearance().tintColor = colors[.secondaryText]
    }
}
