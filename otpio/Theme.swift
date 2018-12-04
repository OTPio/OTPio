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

struct ColorSpace {
    // #MARK: Solarized Colors
    /// SOLARIZED - BRBLACK
    static let solarizedBase03 : UIColor = UIColor(hexString: "#002b36")!
    /// SOLARIZED - BLACK
    static let solarizedBase02 : UIColor = UIColor(hexString: "#073642")!
    /// SOLARIZED - BRGREEN
    static let solarizedBase01 : UIColor = UIColor(hexString: "#586e75")!
    /// SOLARIZED - BRYELLOW
    static let solarizedBase00 : UIColor = UIColor(hexString: "#657b83")!
    /// SOLARIZED - BRBLUE
    static let solarizedBase0  : UIColor = UIColor(hexString: "#839496")!
    /// SOLARIZED - BRCYAN
    static let solarizedBase1  : UIColor = UIColor(hexString: "#93a1a1")!
    /// SOLARIZED - WHITE
    static let solarizedBase2  : UIColor = UIColor(hexString: "#eee8d5")!
    /// SOLARIZED - BRWHITE
    static let solarizedBase3  : UIColor = UIColor(hexString: "#fdf6e3")!
    /// SOLARIZED - YELLOW
    static let solarizedYellow : UIColor = UIColor(hexString: "#b58900")!
    /// SOLARIZED - BRRED
    static let solarizedOrange : UIColor = UIColor(hexString: "#cb4b16")!
    /// SOLARIZED - RED
    static let solarizedRed    : UIColor = UIColor(hexString: "#dc322f")!
    /// SOLARIZED - MAGENTA
    static let solarizedMagenta: UIColor = UIColor(hexString: "#d33682")!
    /// SOLARIZED - BRMAGENTA
    static let solarizedViolet : UIColor = UIColor(hexString: "#6c71c4")!
    /// SOLARIZED - BLUE
    static let solarizedBlue   : UIColor = UIColor(hexString: "#268bd2")!
    /// SOLARIZED - CYAN
    static let solarizedCyan   : UIColor = UIColor(hexString: "#2aa198")!
    /// SOLARIZED - GREEN
    static let solarizedGreen  : UIColor = UIColor(hexString: "#859900")!
    
    // #MARK: Night/Light Mode
    /// NIGHT/LIGHT - BRBLACK
    static let nightlightBlackDark: UIColor = .flatBlackDark
    /// NIGHT/LIGHT - BLACK
    static let nightlightBlack    : UIColor = .flatBlack
    /// NIGHT/LIGHT - WHITE
    static let nightlightWhite    : UIColor = .flatWhite
    /// NIGHT/LIGHT - BRWHITE
    static let nightlightWhiteDark: UIColor = .flatWhiteDark
    /// NIGHT/LIGHT - GRAY
    static let nightlightGray     : UIColor = .flatGray
    /// NIGHT/LIGHT - BRBLUE
    static let nightlightBlue     : UIColor = .flatSkyBlue
    /// NIGHT/LIGHT - BRGRAY
    static let nightlightGrayDark : UIColor = .flatGrayDark
}

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
                .background    : ColorSpace.solarizedBase03,
                .bgHighlight   : ColorSpace.solarizedBase02,
                .normalText    : ColorSpace.solarizedBase0,
                .secondaryText : ColorSpace.solarizedBase01,
                .emphasizedText: ColorSpace.solarizedBase1,
                .progressTrack : ColorSpace.solarizedBlue.withAlphaComponent(0.6),
                .border        : ColorSpace.solarizedCyan.withAlphaComponent(0.5)
            ]
            
        case .solarizedLight:
            return [
                .background    : ColorSpace.solarizedBase3,
                .bgHighlight   : ColorSpace.solarizedBase2,
                .normalText    : ColorSpace.solarizedBase00,
                .secondaryText : ColorSpace.solarizedBase1,
                .emphasizedText: ColorSpace.solarizedBase01,
                .progressTrack : ColorSpace.solarizedYellow.withAlphaComponent(0.6),
                .border        : ColorSpace.solarizedCyan.withAlphaComponent(0.5)
            ]
        case .nightLightDark:
            return  [
                .background    : ColorSpace.nightlightBlackDark,
                .bgHighlight   : ColorSpace.nightlightBlack,
                .normalText    : ColorSpace.nightlightWhiteDark,
                .secondaryText : ColorSpace.nightlightGray,
                .emphasizedText: ColorSpace.nightlightWhite,
                .progressTrack : ColorSpace.nightlightBlue.withAlphaComponent(0.6),
                .border        : ColorSpace.nightlightBlue
            ]
        case .nightLightBright:
            return [
                .background    : ColorSpace.nightlightWhite,
                .bgHighlight   : ColorSpace.nightlightWhiteDark,
                .normalText    : ColorSpace.nightlightBlack,
                .secondaryText : ColorSpace.nightlightGrayDark,
                .emphasizedText: ColorSpace.nightlightBlackDark,
                .progressTrack : ColorSpace.nightlightBlue.withAlphaComponent(0.6),
                .border        : ColorSpace.nightlightBlue
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
