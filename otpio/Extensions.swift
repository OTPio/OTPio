//
//  Extensions.swift
//  otpio
//
//  Created by Mason Phillips on 10/8/18.
//  Copyright © 2018 Matrix Studios. All rights reserved.
//

import UIKit
import SwiftyUserDefaults
import OneTimePassword

final class KeychainIdentifier: Codable, DefaultsSerializable {
    let name: String
    let issuer: String
    let identifier: Data
    
    init(withToken t: Token, andIdentifier i: Data) {
        name = t.name
        issuer = t.issuer
        identifier = i
    }
    
    public func save() {
        
    }
    
    public func token() throws -> PersistentToken {
        let t = try Keychain.sharedInstance.persistentToken(withIdentifier: self.identifier)
        return t!
    }
    
    public static func ==(lt: KeychainIdentifier, rt: KeychainIdentifier) -> Bool {
        return lt.identifier == rt.identifier
    }
}

enum TokenManagementError: Error {
    case urlNotGeneratingToken
}

extension CALayer {
    
    func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        
        let border = CALayer()
        
        switch edge {
        case .top:
            border.frame = CGRect(x: 0, y: 0, width: frame.width, height: thickness)
        case .bottom:
            border.frame = CGRect(x: 0, y: frame.height - thickness, width: frame.width, height: thickness)
        case .left:
            border.frame = CGRect(x: 0, y: 0, width: thickness, height: frame.height)
        case .right:
            border.frame = CGRect(x: frame.width - thickness, y: 0, width: thickness, height: frame.height)
        default:
            break
        }
        
        border.backgroundColor = color.cgColor;
        
        addSublayer(border)
    }
}

extension UIView {
    func fadeTransition(_ duration:CFTimeInterval) {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animation.type = CATransitionType.fade
        animation.duration = duration
        layer.add(animation, forKey: CATransitionType.fade.rawValue)
    }
}

extension Token {
    func iconForToken() -> UIImage? {
        let icon = issuer.closestFontAwesome()
        return UIImage.fontAwesomeIcon(name: icon, style: .brands, textColor: .flatWhite, size: CGSize(width: 30, height: 30))
    }
    
    func iconNameForToken() -> FontAwesome? {
        return issuer.closestFontAwesome()
    }
}

extension String {
    
    func snakeCased() -> String? {
        let pattern = "([a-z0-9])([A-Z])"
        
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        let range = NSRange(location: 0, length: self.count)
        return regex?.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: "$1-$2").lowercased()
    }
    
    subscript(index: Int) -> Character {
        return self[self.index(self.startIndex, offsetBy: index)]
    }

    public func levenshtein(_ other: String) -> Int {
        let sCount = self.count
        let oCount = other.count
        
        guard sCount != 0 else {
            return oCount
        }
        
        guard oCount != 0 else {
            return sCount
        }
        
        let line : [Int]  = Array(repeating: 0, count: oCount + 1)
        var mat : [[Int]] = Array(repeating: line, count: sCount + 1)
        
        for i in 0...sCount {
            mat[i][0] = i
        }
        
        for j in 0...oCount {
            mat[0][j] = j
        }
        
        for j in 1...oCount {
            for i in 1...sCount {
                if self[i - 1] == other[j - 1] {
                    mat[i][j] = mat[i - 1][j - 1]       // no operation
                }
                else {
                    let del = mat[i - 1][j] + 1         // deletion
                    let ins = mat[i][j - 1] + 1         // insertion
                    let sub = mat[i - 1][j - 1] + 1     // substitution
                    mat[i][j] = min(min(del, ins), sub)
                }
            }
        }
        
        return mat[sCount][oCount]
    }
}
