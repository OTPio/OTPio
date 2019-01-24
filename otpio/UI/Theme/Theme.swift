//
//  Theme.swift
//  otpio
//
//  Created by Mason Phillips on 1/11/19.
//  Copyright © 2019 Matrix Studios. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

enum Theme: String, DefaultsSerializable {
    case solarizedDark    = "solarizedDark"
    case solarizedLight   = "solarizedLight"
    case nightLightDark   = "nightLightDark"
    case nightLightBright = "nightLightBright"

    func readableName() -> String {
        switch self {
        case .solarizedDark   : return "Solarized Dark"
        case .solarizedLight  : return "Solarized Light"
        case .nightLightDark  : return "Night/Light Dark"
        case .nightLightBright: return "Night/Light Bright"
        }
    }
    
    func colorsForTheme() -> ThemeColors {
        switch self {
        case .solarizedDark   : return .sdDark
        case .solarizedLight  : return .sdLight
        case .nightLightDark  : return .nlDark
        case .nightLightBright: return .nlBright
        }
    }
    
    struct ThemeColors {
        var backgroundColor : UIColor
        var offsetBackground: UIColor
        
        var normalText      : UIColor
        var secondaryText   : UIColor
        var emphasizedText  : UIColor
        
        var progressTrack   : UIColor
        var border          : UIColor
        
        init(bg: UIColor, off: UIColor, norm: UIColor, sec: UIColor, emp: UIColor, prog: UIColor, bor: UIColor) {
            backgroundColor = bg
            offsetBackground = off
            normalText = norm
            secondaryText = sec
            emphasizedText = emp
            progressTrack = prog
            border = bor
        }
        
        fileprivate static var sdDark: ThemeColors {
            let bg = ColorName.solarizedBase03.color
            let off = ColorName.solarizedBase02.color
            let norm = ColorName.solarizedBase0.color
            let sec = ColorName.solarizedBase01.color
            let emp = ColorName.solarizedBase1.color
            let pro = ColorName.solarizedBlue.color.withAlphaComponent(0.6)
            let bor = ColorName.solarizedCyan.color.withAlphaComponent(0.5)
            return ThemeColors(bg: bg, off: off, norm: norm, sec: sec, emp: emp, prog: pro, bor: bor)
        }
        fileprivate static var sdLight: ThemeColors {
            let bg = ColorName.solarizedBase3.color
            let off = ColorName.solarizedBase2.color
            let norm = ColorName.solarizedBase00.color
            let sec = ColorName.solarizedBase1.color
            let emp = ColorName.solarizedBase01.color
            let pro = ColorName.solarizedYellow.color.withAlphaComponent(0.6)
            let bor = ColorName.solarizedCyan.color.withAlphaComponent(0.5)
            return ThemeColors(bg: bg, off: off, norm: norm, sec: sec, emp: emp, prog: pro, bor: bor)
        }
        fileprivate static var nlDark: ThemeColors {
            let bg = ColorName.nightlightBlackDark.color
            let off = ColorName.nightlightBlack.color
            let norm = ColorName.nightlightWhiteDark.color
            let sec = ColorName.nightlightGray.color
            let emp = ColorName.nightlightWhite.color
            let pro = ColorName.nightlightBlue.color.withAlphaComponent(0.6)
            let bor = ColorName.nightlightBlue.color
            return ThemeColors(bg: bg, off: off, norm: norm, sec: sec, emp: emp, prog: pro, bor: bor)
        }
        fileprivate static var nlBright: ThemeColors {
            let bg = ColorName.nightlightWhite.color
            let off = ColorName.nightlightWhiteDark.color
            let norm = ColorName.nightlightBlack.color
            let sec =  ColorName.nightlightGrayDark.color
            let emp = ColorName.nightlightBlackDark.color
            let pro = ColorName.nightlightBlue.color.withAlphaComponent(0.6)
            let bor = ColorName.nightlightBlue.color
            return ThemeColors(bg: bg, off: off, norm: norm, sec: sec, emp: emp, prog: pro, bor: bor)
        }
    }
}
