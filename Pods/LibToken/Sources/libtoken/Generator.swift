//
//  Generator.swift
//  libtoken
//
//  Created by Mason Phillips on 1/27/19.
//

import Foundation
import CommonCrypto

public struct Generator: Equatable {
    public let secret    : Data
    public let moveFactor: MoveFactor
    public let algorithm : Algorithm
    public let digits    : Int
    
    internal init(secret s: Data, moveFactor f: MoveFactor, tokenAlgoritm a: Algorithm, digits d: Int) {
        secret = s
        moveFactor = f
        algorithm = a
        digits = d
    }
    
    public func password(at time: Date = Date(), format: Bool = false) -> String {
        let interval = processDate(at: time)
        let hash = hmac(stepper: interval)
        
        let truncated = truncate(with: hash)
        
        var rtr = String(truncated).padded(with: "0", toLength: digits)
        let offset = (digits == 8) ? 4 : 3
        if format { rtr.insert(" ", at: rtr.index(rtr.startIndex, offsetBy: offset))}
        
        return rtr
    }
    
    public enum MoveFactor: Equatable {
        case hotp(UInt64)
        case totp(_ validInterval: TimeInterval)
        
        internal func value(at time: Date) -> UInt64 {
            switch self {
            case .hotp(let counter): return counter
            case .totp(let interval):
                let sinceEpoch = time.timeIntervalSince1970
                return UInt64(sinceEpoch / interval)
            }
        }
        
        internal func timeRemaining(at time: Date, _ reversed: Bool = false) -> Float {
            switch self {
            case .hotp(let counter):
                return Float(counter)
            case .totp(let interval):
                let epoch = time.timeIntervalSince1970
                let d = Float(interval - epoch.truncatingRemainder(dividingBy: interval))
                let r = Float(interval) - d
                return (reversed) ? d : r
            }
        }
    }
    
    internal func hmac(stepper: Data) -> Data {
        let (algo, length) = self.algorithm.algorithmDetails()
        let hash = UnsafeMutablePointer<UInt8>.allocate(capacity: Int(length))
        defer { hash.deallocate() }
        
        stepper.withUnsafeBytes { kb in
            self.secret.withUnsafeBytes { db in
                CCHmac(algo, db, self.secret.count, kb, stepper.count, hash)
            }
        }
        
        return Data(bytes: hash, count: Int(length))
    }
    
    internal func processDate(at time: Date = Date()) -> Data {
        let interval = moveFactor.value(at: time)
        var bigInterval = interval.bigEndian
        return Data(bytes: &bigInterval, count: MemoryLayout<UInt64>.size)
    }
    
    internal func truncate(with hash: Data) -> UInt32 {
        var truncated = hash.withUnsafeBytes { (ptr: UnsafePointer<UInt8>) -> UInt32 in
            let offset = ptr[hash.count - 1] & 0x0f
            
            let tptr = ptr + Int(offset)
            
            return tptr.withMemoryRebound(to: UInt32.self, capacity: 1) { $0.pointee }
        }
        
        truncated = UInt32(bigEndian: truncated)
        truncated &= 0x7fffffff
        truncated = truncated % UInt32(pow(10, 6.0))
        
        return truncated
    }
    
    public static func ==(l: Generator, r: Generator) -> Bool {
        return (l.algorithm == r.algorithm) &&
               (l.digits == r.digits) &&
               (l.secret == r.secret)
    }
}
