//
//  Constants.swift
//  otpio
//
//  Created by Mason Phillips on 2/12/19.
//  Copyright © 2019 Matrix Studios. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

struct Constants {
    
}

extension DefaultsKeys {
    static var currentTheme = DefaultsKey<Theme>("currentTheme", defaultValue: Theme.default)
    static var cloud        = DefaultsKey<Bool>("allowCloud", defaultValue: false)
    static var today        = DefaultsKey<Bool>("allowToday", defaultValue: false)
}
