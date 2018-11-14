//
//  Extensions.swift
//  otpio
//
//  Created by Mason Phillips on 10/8/18.
//  Copyright © 2018 Matrix Studios. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

func fetchString(forKey k: String) -> String {
    var result = Bundle.main.localizedString(forKey: k, value: nil, table: nil)
    
    if result == k {
        result = Bundle.main.localizedString(forKey: k, value: nil, table: "Default")
    }
    
    return result
}
