//
//  Extensions.swift
//  libfa
//
//  Created by Mason Phillips on 1/20/19.
//

import Foundation

extension FontAwesome {
    public func iconName() -> String? {
        let v = self.rawValue
        let rtr = FontAwesomeIcons.filter { $0.value == v }
        return rtr.first?.key
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
