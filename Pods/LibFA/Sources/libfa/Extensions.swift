//
//  Extensions.swift
//  libfa
//
//  Created by Mason Phillips on 1/20/19.
//

import Foundation

extension FontAwesome {
    public var iconName: String {
        let v = self.rawValue
        let rtr = FontAwesomeIcons.filter { $0.value == v }
        return rtr.first!.key
    }
    
    public var humanName: String {
        var s = self.iconName
        s = String(s.dropFirst(3))
        s = s.replacingOccurrences(of: "-", with: " ")
        return s.capitalized
    }
    
    public static var mappedBrands: Array<(k: String, v: FontAwesome)> {
        return FontAwesomeBrands.map { (key: String, value: String) in
            return (k: key, v: FontAwesome(rawValue: value)!)
            }.sorted { $0.k < $1.k }
    }
}

extension String {
    public func closestBrand() -> FontAwesome {
        let keys = Array(FontAwesomeBrands.keys).sortedByFuzzyMatchPattern(self)
        let firstKey = keys.first!
        let value = FontAwesomeBrands[firstKey]!
        return FontAwesome(rawValue: value)!
    }
}
