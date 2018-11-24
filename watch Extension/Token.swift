//
//  Token.swift
//  watch Extension
//
//  Created by Mason Phillips on 11/15/18.
//  Copyright © 2018 Matrix Studios. All rights reserved.
//

import Foundation
import SwiftBase32

/// A stripped-down version of the regular Token
class Token: CustomStringConvertible, Equatable {
    public let secret: Data
    public let issuer: String
    public let label : String

    public var description: String {
        return "Token<Stripped>"
    }

    public init(secret s: Data, issuer i: String, label l: String) {
        self.secret = s
        self.issuer = i
        self.label  = l
    }

    public convenience init(from u: URL) {
        let components = URLComponents(url: u, resolvingAgainstBaseURL: false)
        let query = components?.queryItems!

        let secretString = query!.filter { $0.name == "secret" }.first!
        let secretData   = secretString.value!.base32DecodedData!

        let issuerString = query!.filter { $0.name == "issuer" }.first!.value!

        let labelString = String(u.path.dropFirst())

        self.init(secret: secretData, issuer: issuerString, label: labelString)
    }

    public func password() -> String {
        let date = Date()
        let interval = processDate(at: date)
        let hash = hmac(stepper: interval)
        
        let truncated = truncate(with: hash)
        
        let rtr = String(truncated).padded(with: "0", toLength: 6)
        
        return rtr
    }
    
    public func timeRemaining(reversed: Bool = false) -> Int {
        let time: TimeInterval = 30.0
        let epoch = Date().timeIntervalSince1970
        let d = Float(time - epoch.truncatingRemainder(dividingBy: time))
        let r = 30 - d
        return (reversed) ? Int(d) : Int(r)
    }
    
    public static func ==(l: Token, r: Token) -> Bool {
        return l.secret == r.secret
    }
}
