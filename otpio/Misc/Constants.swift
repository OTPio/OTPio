//
//  Constants.swift
//  otpio
//
//  Created by Mason Phillips on 1/11/19.
//  Copyright © 2019 Matrix Studios. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

struct Constants {
    enum CellIdentifiers: String {
        case menu = "menuCell"
    }
}

extension Notification.Name {
    static var themeDidChange = Notification.Name("themeDidChange")
}

extension DefaultsKeys {
    static var theme: DefaultsKey = DefaultsKey<Theme>("theme", defaultValue: .nightLightDark)
}
