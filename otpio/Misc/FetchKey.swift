//
//  FetchKey.swift
//  otpio
//
//  Created by Mason Phillips on 2/13/19.
//  Copyright © 2019 Matrix Studios. All rights reserved.
//

import Foundation

func fetchString(forKey k: String) -> String {
    var result = Bundle.main.localizedString(forKey: k, value: nil, table: nil)
    
    if result == k {
        result = Bundle.main.localizedString(forKey: k, value: nil, table: "Default")
    }
    
    return result
}
