//
//  SwiftyDefaultKeys.swift
//  otpio
//
//  Created by Mason Phillips on 12/3/18.
//  Copyright © 2018 Matrix Studios. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

extension DefaultsKeys {
    static let currentTheme = DefaultsKey<Theme>("theme", defaultValue: .nightLightDark)
    static let cellSize     = DefaultsKey<CellType>("cellSize", defaultValue: .compact)
    static let allowsToday = DefaultsKey<Bool>("allowToday")
    static let allowsCloud = DefaultsKey<Bool>("allowCloud")

}
