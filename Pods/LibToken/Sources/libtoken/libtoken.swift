//
//  libtoken.swift
//  libtoken
//
//  Created by Mason Phillips on 11/11/18.
//

import Foundation
import CommonCrypto
import LibFA

public class Token: CustomStringConvertible, Equatable {
    public let secret: Data
    public var issuer: String
    public var label : String
    
    public var digits: Int
    public var interval: TimeInterval
    
    public var algorithm: TokenAlgorithm
    
    public var faIcon: FontAwesome
    
    public var description: String {
        let ctr = ByteCountFormatter()
        ctr.allowedUnits = .useBytes
        let brtr = ctr.string(fromByteCount: Int64(secret.count))
        let srtr = secret.hexEncodedString()
        
        let fakey = FontAwesomeIcons.filter { $0.value == faIcon.rawValue }
        
        var rtr = ""
        rtr += "Token - \(self.issuer) (\(self.label))\n"
        rtr += "Secret: 0x\(srtr) (\(brtr))\n"
        rtr += "FontAwesomeIcon: \(fakey.keys.first!)"
        
        return rtr
    }
    
    public init(secret s: Data, issuer i: String, label l: String, digits d: Int = 6, interval n: TimeInterval = 30, algorithm a: TokenAlgorithm = .sha1, faIcon f: FontAwesome? = nil) {
        secret = s
        issuer = i
        label  = l
        
        digits = d
        interval = n
        
        algorithm = a
        
        faIcon = f ?? i.closestBrand()
    }
    
    public convenience init?(from u: URL) {
        do {
            let components = URLComponents(url: u, resolvingAgainstBaseURL: false)
            
//            guard components?.path == "otpauth" else { throw Deserialization.pathInvalid }
            
            guard let query = components?.queryItems else { throw Deserialization.queryItemsNotFound }
            
            let secretString = query.filter { $0.name == "secret" }
            guard let first = secretString.first else { throw Deserialization.secretNotFound }
            guard let secret = first.value else { throw Deserialization.secretNotFound }
            let secretData = try secret.decodeBase32()

            
            let issuerString = query.filter { $0.name == "issuer" }
            guard let issuer = issuerString.first?.value else { throw Deserialization.issuerNotFound }
            
            let labelString = String(u.path.dropFirst())
            
            let faFilter = query.filter { $0.name == "fa" }
            let faString = faFilter.first?.value ?? ""
            let icon = faString.closestBrand()
            
            let digitsFilter = query.filter { $0.name == "digits" }
            let digitsString = digitsFilter.first?.value ?? "6"
            let digits = Int(digitsString) ?? 6
            guard 6...8 ~= digits else { throw Deserialization.digitsLengthInvalid }
            
            let intervalFilter = query.filter { $0.name == "period" || $0.name == "interval" }
            let intervalString = intervalFilter.first?.value ?? "30"
            let interDou = Double(intervalString) ?? 30
            let interval = TimeInterval(interDou)
            
            let algoFilter = query.filter {$0.name == "algorithm" }
            let algoString = algoFilter.first?.value ?? "sha1"
            let algorithm = TokenAlgorithm(rawValue: algoString)
            
            self.init(secret: secretData, issuer: issuer, label: labelString, digits: digits, interval: interval, algorithm: algorithm, faIcon: icon)
        } catch {
            return nil
        }
    }
    
    public func password(at time: Date = Date(), format: Bool = false) -> String {
        let interval = processDate(at: time)
        let hash = hmac(stepper: interval)
        
        let truncated = truncate(with: hash)
        
        var rtr = String(truncated).padded(with: "0", toLength: self.digits)
        let offset = (self.digits == 8) ? 4 : 3
        if format { rtr.insert(" ", at: rtr.index(rtr.startIndex, offsetBy: offset))}
        
        return rtr
    }
    
    public func serialize() -> String {
        var components: URLComponents = URLComponents()
        components.scheme = "otpauth"
        components.path = "/\(self.label)"
        components.host = "totp"
        
        let fastring = FontAwesomeBrands.filter { $0.value == self.faIcon.rawValue }.first!
        
        let items: Array<URLQueryItem> = [
            URLQueryItem(name: "secret", value: self.secret.base32String()),
            URLQueryItem(name: "issuer", value: self.issuer),
            URLQueryItem(name: "algorithm", value: self.algorithm.algorithmName()),
            URLQueryItem(name: "digits", value: "\(Int(self.digits))"),
            URLQueryItem(name: "period", value: "\(self.interval)"),
            URLQueryItem(name: "fa", value: fastring.key)
        ]
        
        components.queryItems = items
        
        let url = components.url!
        
        return url.absoluteString
    }
    
    public func timeRemaining(_ reversed: Bool = false) -> Float {
        let epoch = Date().timeIntervalSince1970
        let d = Float(self.interval - epoch.truncatingRemainder(dividingBy: self.interval))
        let r = Float(self.interval) - d
        return (reversed) ? d : r
    }
    
    public static func ==(_ l: Token, _ r: Token) -> Bool {
        return l.secret.hashValue == r.secret.hashValue
    }
}

