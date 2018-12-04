//
//  Extensions.swift
//  otpio
//
//  Created by Mason Phillips on 10/8/18.
//  Copyright © 2018 Matrix Studios. All rights reserved.
//

import UIKit
import SwiftyUserDefaults
import libfa
import FuzzyMatchingSwift

func fetchString(forKey k: String) -> String {
    var result = Bundle.main.localizedString(forKey: k, value: nil, table: nil)
    
    if result == k {
        result = Bundle.main.localizedString(forKey: k, value: nil, table: "Default")
    }
    
    return result
}

extension FontAwesome {
    static var mappedBrands: Array<(String, FontAwesome)> = {
        let pre = FontAwesomeBrands.map({ (k: String, v: String) -> (String, FontAwesome) in
            let fa = FontAwesome(rawValue: v)!
            let kk = fa.iconName()!
            return (kk, fa)
        })
        let post = pre.sorted { $0.0 < $1.0 }
        return post
    }()
    
    public func iconName() -> String? {
        let v = self.rawValue
        
        let rtr = FontAwesomeIcons.filter { $0.value == v }
        
        guard var key = rtr.first?.key else { return nil }
        
        key = String(key.dropFirst(3))
        key = key.replacingOccurrences(of: "-", with: " ")
        
        return key.capitalized
    }
}

