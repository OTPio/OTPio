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
        } catch {
            print("Keychain error: could not retrieve all tokens")
            currentTokens = []
        }

        tokenTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (_) in
            self.startTokenUpdater()
        })
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
    }
    
    public func fetchAll() -> [Token] {
        return currentTokens
    }

    @objc func startTokenUpdater() {
        var newTokens: [Token] = []
        for i in 0..<self.currentTokens.count {
            let t = self.currentTokens[i]
            let nt = t.updatedToken()
            newTokens.append(nt)
        }
        
        self.currentTokens = newTokens
        
        let count = self.generateOffset()
        let p = Float(count/30)
        self.currentTokens = newTokens
        self.listener?.tokensUpdated(tokens: self.currentTokens, time: p)
    }
    
    func stopAllTimers() {
        tokenTimer?.invalidate()
    }
    
    func generateOffset() -> Float {
        guard let t = self.currentTokens.first else { return 0.0 }
        switch t.generator.factor {
        case .timer(let time):
            let epoch = Date().timeIntervalSince1970
            let d = Int(time - epoch.truncatingRemainder(dividingBy: time))
            return Float(30 - d)
        default: return 0.0
        }
    }
}

protocol TokenOperationsListener {
    func tokensUpdated(tokens t: Array<Token>, time: Float)
}
