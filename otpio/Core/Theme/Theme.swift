//
//  Theme.swift
//  otpio
//
//  Created by Mason Phillips on 2/12/19.
//  Copyright © 2019 Matrix Studios. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

enum Theme: String, DefaultsSerializable {
    static let `default`: Theme = .nightLightDark
    case solarizedLight, solarizedDark
    case nightLightDark, nightLightBright
}
