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

class System {
    public static let sharedInstance: System = System()
    public var listener: TokenOperationsListener?
        
    private let keychain: Keychain
    
    private var currentTokens: [Token]
    public var tokenTimer: Timer?
    
    init() {
        keychain = Keychain.sharedInstance
        currentTokens = []
        setup()
    }
    
    public func setup() {
        do {
            let p = try keychain.allPersistentTokens()
            currentTokens = p.map({ (t) -> Token in
                return t.token
            })
            currentTokens = currentTokens.sorted(by: { (left, right) -> Bool in
                return left.issuer < right.issuer
            })
        } catch {
            print("Keychain error: could not retrieve all tokens")
            currentTokens = []
        }
        
        listener?.tokensUpdated(tokens: currentTokens)
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
        
        currentTokens.append(t)
        do {
            _ = try keychain.add(t)
        } catch let e {
            print("Keychain error: \(e)")
        }
        
        currentTokens = currentTokens.sorted(by: { (left, right) -> Bool in
            return left.issuer < right.issuer
        })
        
        listener?.tokensUpdated(tokens: currentTokens)
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
