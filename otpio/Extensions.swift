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
        var search = self.issuer
        
        search = search.replacingOccurrences(of: " ", with: "-")
        for (k, _) in FontAwesomeIcons {
            guard k.range(of: search.lowercased()) != nil else { continue }
            
            let i = UIImage.fontAwesomeIcon(code: k, style: .brands, textColor: .flatWhite, size: CGSize(width: 30, height: 30))
            return i
        }
        
        for (k, _) in FontAwesomeIcons {
            let s = search.lowercased()
            let ss = String(k.dropFirst(3))
            guard s.range(of: ss) != nil else { continue }
            
            let i = UIImage.fontAwesomeIcon(code: k, style: .brands, textColor: .flatWhite, size: CGSize(width: 30, height: 30))
            return i
        }
        
        search = search.snakeCased()!
        for (k, _) in FontAwesomeIcons {
            guard k.range(of: search) != nil else { continue }
            
            let i = UIImage.fontAwesomeIcon(code: k, style: .brands, textColor: .flatWhite, size: CGSize(width: 30, height: 30))
            return i
        }
        
        return nil
    }
}

extension String {
    
    func snakeCased() -> String? {
        let pattern = "([a-z0-9])([A-Z])"
        
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        let range = NSRange(location: 0, length: self.count)
        return regex?.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: "$1-$2").lowercased()
    }
}
