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

extension DefaultsKeys {
    static let identifiers = DefaultsKey<[KeychainIdentifier]?>("identifiers")
}

enum TokenManagementError: Error {
    case urlNotGeneratingToken
}
