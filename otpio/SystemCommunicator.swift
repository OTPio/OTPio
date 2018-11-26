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
    private var fullToken   : Array<Token>
    
    private let todayKeychain: Keychain
    private var todayToken: Array<Token>
    
    private let cloudKeychain: Keychain
    private var cloudToken   : Array<Token>
    
    init() {
        fullKeychain = Keychain(service: "com.otpio.token", accessGroup: "6S4L29QT59.com.otpio.fullkeychain")
        .synchronizable(false)
        .accessibility(.always)
        
        fullToken   = []
        
        todayKeychain = Keychain(service: "com.otpio.token", accessGroup: "6S4L29QT59.com.otpio.todaykeychain")
        .synchronizable(false)
        .accessibility(.afterFirstUnlockThisDeviceOnly)
        
        todayToken = []
        
        cloudKeychain = Keychain(service: "com.otpio.token", accessGroup: "6S4L29QT59.com.otpio.cloudkeychain")
        .synchronizable(true)
        .accessibility(.afterFirstUnlock)
        
        cloudToken = []
    }

    public func updateKeychain() {
        DispatchQueue.global(qos: .background).async {
            try? self.fullKeychain.removeAll()
            try? self.todayKeychain.removeAll()
            try? self.cloudKeychain.removeAll()
            
            for t in self.fullToken {
                self.fullKeychain[String(t.secret.hashValue)] = t.serialize()
            }
            
            for t in self.todayToken {
                self.todayKeychain["today-\(t.secret.hashValue)"] = t.serialize()
            }
            
            for t in self.cloudToken {
                self.cloudKeychain["cloud=\(t.secret.hashValue)"] = t.serialize()
            }
            
            self.listener?.returned(tokens: self.fullToken)
        }
    }
    
    public func add(token t: Token) {
        fullToken.append(t)
        
        updateKeychain()
    }
    public func update() {
        updateKeychain()
    }
    public func remove(token t: Token) {
        guard let offset = fullToken.firstIndex(of: t) else { return }
        fullToken.remove(at: offset)
        
        // If a token is removed from the full chain, it should also be removed from the other chains
        removeFromToday(token: t)
        removeFromCloud(token: t)
                
        updateKeychain()
    }
    
    public func sendToToday(token t: Token) {
        todayToken.append(t)
        updateKeychain()
    }
    public func removeFromToday(token t: Token) {
        guard let offset = todayToken.firstIndex(of: t) else { return } // Index not present
        todayToken.remove(at: offset)
        updateKeychain()
    }
    public func isInToday(token t: Token) -> Bool {
        guard todayToken.firstIndex(of: t) != nil else { return false}
        return true
    }
    
    public func sendToCloud(token t: Token) {
        cloudToken.append(t)
        updateKeychain()
    }
    public func removeFromCloud(token t: Token) {
        guard let offset = cloudToken.firstIndex(of: t) else { return }
        cloudToken.remove(at: offset)
        updateKeychain()
    }
    public func isInCloud(token t: Token) -> Bool {
        guard cloudToken.firstIndex(of: t) != nil else { return false }
        return true
    }
    
    public func allTokens() {
        listener?.beganLoading()
        DispatchQueue.global(qos: .utility).async {
            let raw = self.fullKeychain.allItems()
            self.fullToken = raw.compactMap({ (input) -> Token? in
                guard let tUrl: String = input["value"] as? String else { return nil }
                guard let url: URL = URL(string: tUrl) else { return nil }
                
                return Token(from: url)
            })
            
            let rawToday = self.todayKeychain.allItems()
            self.todayToken = rawToday.compactMap({ (input) -> Token? in
                guard let tUrl: String = input["value"] as? String else { return nil }
                guard let url: URL = URL(string: tUrl) else { return nil }
                
                return Token(from: url)
            })
            
            let rawCloud = self.cloudKeychain.allItems()
            self.cloudToken = rawCloud.compactMap({ (input) -> Token? in
                guard let tUrl: String = input["value"] as? String else { return nil }
                guard let url: URL = URL(string: tUrl) else { return nil }
                
                return Token(from: url)
            })

            DispatchQueue.main.async {
                self.listener?.returned(tokens: self.fullToken)
            }
        }
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
    func beganLoading()
    func returned(tokens t: Array<Token>)
    func startTimers()
    func stopTimers()
}
