//
//  Extensions.swift
//  libtoken
//
//  Created by Mason Phillips on 11/11/18.
//

import Foundation
import CommonCrypto
import LibFA

// MARK: - Internal Token parsing extensions
extension Token {
    static func parseSecret(with us: [URLQueryItem]) throws -> Data {
        let item = us.filter { $0.name == "secret" }
        guard let str = item.first?.value else { throw TokenError.secretNotFound }
        return try Token.parseSecret(with: str)
    }
    static func parseSecret(with d: String) throws -> Data {
        let u = d.uppercased()
        return try u.decodeBase32()
    }
    
    static func parseTokenIssuer(with us: [URLQueryItem], andLabel l: String) throws -> String {
        let ret: String
        let split = l.split(separator: ":").map { return String($0) }
        if split.count > 1 {
            ret = split.first!
        } else {
            let item = us.filter { $0.name == "issuer" }
            guard let issuer = item.first?.value else { throw TokenError.issuerNotFound }
            ret = issuer
        }
        guard ret.first == "/" else { return ret }
        return String(ret.dropFirst())
    }
    
    static func parseUser(with l: String) -> String {
        let ret: String
        let split = l.split(separator: ":").map { return String($0) }
        if split.count > 1 {
            ret = String(split.last!)
        } else {
            ret = String(l)
        }
        
        guard ret.first == "/" else { return ret }
        return String(ret.dropFirst())
    }
    
    static func parseFactor(with type: String, andItems i: [URLQueryItem]) throws -> Generator.MoveFactor {
        let item = i.filter { $0.name == "interval" || $0.name == "period" }
        let str = item.first?.value
        return try Token.parseFactor(with: type, andCounter: str)
    }
    static func parseFactor(with type: String, andCounter c: String?) throws -> Generator.MoveFactor {
        switch type.lowercased() {
        case "totp":
            guard
                let counter = c,
                let time    = TimeInterval(counter)
                else { return .totp(30) }
            return .totp(time)
        case "hotp":
            guard
                let counter = c,
                let time    = UInt64(counter)
                else { throw TokenError.hotpFactorNotParsable }
            return .hotp(time)
        default: throw TokenError.moveFactorTypeNotFound
        }
    }
    
    static func parseAlgorithm(with us: [URLQueryItem]) throws -> Algorithm {
        let item = us.filter { $0.name == "algorithm" }
        guard let str = item.first?.value else { return .sha1 }
        guard let algorithm = Algorithm(rawValue: str) else {
            // Deciding to throw here because if we actually have a parameter,
            // we should be able to parse it, or understand why we can't
            throw TokenError.algorithmNotParsable
        }
        
        return algorithm
    }
    
    static func parseDigits(with us: [URLQueryItem]) throws -> Int {
        let item = us.filter { $0.name == "digits" }
        guard let str = item.first?.value else { return 6 }
        guard let digits = Int(str) else {
            // Deciding to throw here because if we actually have a parameter,
            // we should be able to parse it, or understand why we can't
            throw TokenError.digitsNotParsable
        }
        return digits
    }
    
    static func parseFontAwesome(with us: [URLQueryItem], issuer i: String) throws -> FontAwesome {
        let item = us.filter { $0.name == "fa" }
        if let str = item.first?.value {
            guard let item = FontAwesome.fromCode(str) else {
                throw TokenError.fontAwesomeNotParsable
            }
            return item
        } else {
            return i.closestBrand()
        }
    }
}

// MARK: - Data extensions
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

// MARK: - String extensions
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

// MARK: - URL extensions
public extension URL {
    func tokenFromURL() throws -> Token? {
        return Token(with: self)
    }
}
