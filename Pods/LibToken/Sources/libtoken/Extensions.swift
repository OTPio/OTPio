//
//  Extensions.swift
//  libtoken
//
//  Created by Mason Phillips on 11/11/18.
//

import Foundation
import CommonCrypto

internal extension Data {
    struct HexEncodingOptions: OptionSet {
        let rawValue: Int
        static let upperCase = HexEncodingOptions(rawValue: 1 << 0)
    }
    
    func hexEncodedString(options: HexEncodingOptions = []) -> String {
        let hexDigits = Array((options.contains(.upperCase) ? "0123456789ABCDEF" : "0123456789abcdef").utf16)
        var chars: [unichar] = []
        chars.reserveCapacity(2 * count)
        for byte in self {
            chars.append(hexDigits[Int(byte / 16)])
            chars.append(hexDigits[Int(byte % 16)])
        }
        return String(utf16CodeUnits: chars, count: chars.count)
    }
}

internal extension String {
    func padded(with character: Character, toLength length: Int) -> String {
        let paddingCount = length - count
        guard paddingCount > 0 else {
            return self
        }
        
        let padding = String(repeating: String(character), count: paddingCount)
        return padding + self
    }
}

extension Token {
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
        let epoch = time.timeIntervalSince1970
        let interval = UInt64(epoch / self.interval)
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
}
