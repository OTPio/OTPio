//
//  SystemCommunicator.swift
//  otpio
//
//  Created by Mason Phillips on 10/8/18.
//  Copyright © 2018 Matrix Studios. All rights reserved.
//

import UIKit
import OneTimePassword
import QRCodeReader
import KeychainSwift

class System {
    public static let sharedInstance: System = System()
    public var listener: TokenOperationsListener?
    
    private let fullKeychain: KeychainSwift   // The default, local keychain
    private let todayKeychain: KeychainSwift  // The keychain used for the Today view
    private let cloudKeychain: KeychainSwift  // The keychain used for synchronizing with iCloud
    
    private var currentTokens: [Token]
    private var persistantTokens: Set<PersistentToken>
    public var tokenTimer: Timer?
    
    init() {
        fullKeychain = KeychainSwift()
        fullKeychain.synchronizable = false
        fullKeychain.accessGroup = "com.otpio.fullkeychain"
        
        todayKeychain = KeychainSwift()
        todayKeychain.synchronizable = false
        todayKeychain.accessGroup = "com.otpio.todaykeychain"
        
        cloudKeychain = KeychainSwift()
        cloudKeychain.synchronizable = true
        cloudKeychain.accessGroup = "com.otpio.cloudkeychain"
        
        currentTokens = []
        persistantTokens = []
        
        setup()
    }
    
    public func setup() {
//        do {
//            let p = try keychain.allPersistentTokens()
//            persistantTokens = p
//            currentTokens = p.map({ (t) -> Token in
//                return t.token
//            })
//            currentTokens = currentTokens.sorted(by: { (left, right) -> Bool in
//                return left.issuer < right.issuer
//            })
//        } catch {
//            print("Keychain error: could not retrieve all tokens")
//            currentTokens = []
//        }
//
//        if currentTokens.count > 0 { self.uploadToCloud() }
//        listener?.tokensUpdated(tokens: currentTokens)
    }
    
    public func fetchFromCloud() {
//        do {
//            guard let tokenStrings: String = cloud.get("token_urls") else { throw TokenSync.noTokens }
//
//            let tokenArray = tokenStrings.split(separator: "|")
//
//            for t in tokenArray {
//                guard let url = URL(string: String(t)) else { throw TokenSync.urlStringNotConvertible }
//                self.generate(using: url)
//            }
//        } catch let e {
//            if let e = e as? TokenSync {
//                switch e {
//                case .noTokens:
//                    print("No tokens could be found")
//                case .urlStringNotConvertible:
//                    print("Could not convert to URL")
//                }
//            } else {
//                print(e)
//            }
//        }
    }
    
    public func uploadToCloud() {
//        do {
//            let keys = try keychain.allPersistentTokens()
//            var strings: Array<String> = []
//            
//            for k in keys {
//                let u = try k.token.toURL()
//                let s = u.absoluteString
//                strings.append(s)
//            }
//            
//            let cstring = strings.joined(separator: "|")
//            cloud.set(cstring, forKey: "token_urls")
//        } catch let e {
//            print("Keychain error while uploading: \(e)")
//        }
    }
    
    public func textCallback(result: String) {
        guard let url: URL = URL(string: result) else { return }
        
        self.generate(using: url)
    }
    
    public func qrCallback(result: QRCodeReaderResult?) {
        guard let value: String = result?.value else { return }
        guard let url: URL = URL(string: value) else { return }
        
        print(value)
        self.generate(using: url)
    }
    
    public func generate(using u: URL) {
        guard let t: Token = Token(url: u) else { return }
        print("Current PIN: \(t.currentPassword!)")
        
        for tt in currentTokens {
            if tt == t { print("Token already exists, canceling"); return }
        }
        
        currentTokens.append(t)
        do {
            //_ = try keychain.add(t)
        } catch let e {
            print("Keychain error: \(e)")
        }
        
        currentTokens = currentTokens.sorted(by: { (left, right) -> Bool in
            return left.issuer < right.issuer
        })
        
        listener?.tokensUpdated(tokens: currentTokens)
    }
    
    public func remove(token t: Token) {
        do {
            let persist = persistantTokens.filter { (p) -> Bool in
                return p.token == t
            }
            
            if persist.count != 1 {
                throw Keychain.Error.incorrectReturnType
            }
            
            let p = persist.first!
            //_ = try keychain.delete(p)
        } catch let e {
            print("Keychain Error: \(e)")
        }
        
        self.setup()
    }
    
    public func fetchAll() -> [Token] {
        return currentTokens
    }
    
    public func stopAllTimers() {
        listener?.stopTimers()
    }
    
    public func restartTimers() {
        listener?.restartTimers()
    }
}

protocol TokenOperationsListener {
    func tokensUpdated(tokens t: Array<Token>)
    func stopTimers()
    func restartTimers()
}

enum TokenSync: Error {
    case noTokens, urlStringNotConvertible
}
