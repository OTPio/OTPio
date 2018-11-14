//
//  SystemCommunicator.swift
//  otpio
//
//  Created by Mason Phillips on 11/13/18.
//  Copyright © 2018 Matrix Studios. All rights reserved.
//

import Foundation
import libtoken
import libfa
import SwiftyUserDefaults
import KeychainAccess

class SystemCommunicator {
    public static let sharedInstance: SystemCommunicator = SystemCommunicator()
    public var listener: TokenOperationsListener?
    
    private let fullKeychain: Keychain
    private var fullToken: Array<Token>
    
    init() {
        fullKeychain = Keychain(service: "com.otpio.token", accessGroup: "6S4L29QT59.com.otpio.fullkeychain")
        .synchronizable(false)
        .accessibility(.afterFirstUnlock)
        
        fullToken = []
    }
    
    public func add(token t: Token) {
        let url = t.serialize()
        
        do {
            try fullKeychain.set(url, key: "\(t.secret.hashValue)")
            
            fullToken.append(t)
        } catch let e {
            print(e.localizedDescription)
        }
    }
    
    public func allTokens() {
        let raw = fullKeychain.allItems()
        
        self.fullToken = raw.compactMap({ (input) -> Token? in
            guard let tUrl: String = input["value"] as? String else { return nil }
            guard let url: URL = URL(string: tUrl) else { return nil }
            
            return Token(from: url)
        })
        
        listener?.returned(tokens: self.fullToken)
    }
    
    public func stopTimer() {
        listener?.stopTimers()
    }
    
    public func restartTimer() {
        listener?.startTimers()
    }
}

extension DefaultsKeys {
    static let allowsToday = DefaultsKey<Bool>("allowToday")
    static let allowsCloud = DefaultsKey<Bool>("allowCloud")
}

protocol TokenOperationsListener {
    func returned(tokens t: Array<Token>)
    func startTimers()
    func stopTimers()
}
