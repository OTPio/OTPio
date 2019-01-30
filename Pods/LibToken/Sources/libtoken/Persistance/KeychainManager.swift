//
//  Keychain.swift
//  libtoken
//
//  Created by Mason Phillips on 1/28/19.
//

import Foundation

public final class TokenManager {
    public static let shared: TokenManager = TokenManager()
    
    public var listener: KeychainListener?
    
    private var keychainTypes: [KeychainType]?
    private var keys         : LibtokenKeys
    
    private let fullKeychain : Keychain
    private var fullTokens   : [Token] {
        didSet(new) {
            listener?.didUpdate(tokens: new)
        }
    }
    
    private var cloudKeychain: Keychain?
    private var cloudTokens  : [Token]!
    
    private var todayKeychain: Keychain?
    private var todayTokens  : [Token]!
    
    init() {
        keys = LibtokenKeys()
        
        fullKeychain = Keychain(service: "com.otpio.keychain", accessGroup: keys.fullAccess)
        .synchronizable(false)
        .accessibility(.always)
        
        fullTokens = fullKeychain.allItems().compactMap { Token($0) }
    }
    
    public func configure(with t: [KeychainType]) {
        guard t.count > 0 else {
            fatalError("Must configure more than one keychain")
        }
        
        if t.contains(.cloud) {
            cloudKeychain = Keychain(service: "com.otpio.keychain", accessGroup: keys.cloudAccess)
            .synchronizable(false)
            .accessibility(.afterFirstUnlock)
            cloudTokens = cloudKeychain!.allItems().compactMap { Token($0) }
        }
        
        if t.contains(.today) {
            todayKeychain = Keychain(service: "com.otpio.keychain", accessGroup: keys.todayAccess)
            .synchronizable(false)
            .accessibility(.afterFirstUnlock)
            todayTokens = todayKeychain!.allItems().compactMap { Token($0) }
        }
    }
    
    public func add(token t: Token) {
        fullTokens.append(t)
        updateKeychain()
    }
    
    public func addTo(type t: KeychainType, token k: Token) {
        switch t {
        case .today:
            guard todayKeychain != nil else {
                fatalError("Trying to use a keychain type that has not been set up. Call configure(with:) first")
            }
            todayTokens.append(k)
        case .cloud:
            guard cloudKeychain != nil else {
                fatalError("Trying to use a keychain type that has not been set up. Call configure(with:) first")
            }
            cloudTokens.append(k)
        case .full:
            fullTokens.append(k)
        }
        updateKeychain()
    }
    public func isIn(type t: KeychainType, token k: Token) -> Bool {
        switch t {
        case .today:
            guard todayKeychain != nil else {
                fatalError("Trying to use a keychain type that has not been set up. Call configure(with:) first")
            }
            return todayTokens.contains(k)
        case .cloud:
            guard cloudKeychain != nil else {
                fatalError("Trying to use a keychain type that has not been set up. Call configure(with:) first")
            }
            return cloudTokens.contains(k)
        case .full: return true
        }
    }
    public func remove(type t: KeychainType, token k: Token) {
        switch t {
        case .today:
            guard todayKeychain != nil else {
                fatalError("Trying to use a keychain type that has not been set up. Call configure(with:) first")
            }
            todayTokens = todayTokens.filter { $0 != k }
        case .cloud:
            guard cloudKeychain != nil else {
                fatalError("Trying to use a keychain type that has not been set up. Call configure(with:) first")
            }
            cloudTokens = cloudTokens.filter { $0 != k }
        case .full:
            fullTokens = fullTokens.filter { $0 != k }
        }
        updateKeychain()
    }
    
    public func allTokens() -> [Token] {
        return fullTokens
    }
    
    private func updateKeychain() {
        DispatchQueue.global(qos: .background).async {
            for t in self.fullTokens {
                self.fullKeychain[String(t.generator.secret.hashValue)] = try? t.serialize().absoluteString
            }
            
            if
                let k = self.cloudKeychain,
                let t = self.cloudTokens {
                for s in t {
                    k[String(s.generator.secret.hashValue)] = try? s.serialize().absoluteString
                }
            }
            
            if
                let k = self.todayKeychain,
                let t = self.todayTokens {
                for s in t {
                    k[String(s.generator.secret.hashValue)] = try? s.serialize().absoluteString
                }
            }
        }
    }
    
    public enum KeychainType {
        case today, cloud, full
    }
}

public protocol KeychainListener {
    func didUpdate(tokens: [Token])
}
