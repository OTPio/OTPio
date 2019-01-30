//
//  libtoken.swift
//  libtoken
//
//  Created by Mason Phillips on 11/11/18.
//
// All code conforms to RFC 4226 (https://tools.ietf.org/html/rfc4226)

import Foundation
import LibFA

public final class Token: NSObject {
    public var issuer     : String
    public var user       : String
    public var fontAwesome: FontAwesome
    public var generator  : Generator
    
    public var currentPassword: String? {
        return generator.password(at: Date(), format: true)
    }
    
    override public var description: String {
        let ctr = ByteCountFormatter()
        ctr.allowedUnits = .useBytes
        let brtr = ctr.string(fromByteCount: Int64(generator.secret.count))
        let srtr = generator.secret.hexEncodedString()
        
        var rtr = ""
        rtr += "Token - \(self.issuer) (\(self.user))\n"
        rtr += "Secret: 0x\(srtr) (\(brtr))"
        
        return rtr
    }
    
    public init(generator g: Generator, tokenIssuer t: String, user u: String, fontAwesome f: FontAwesome? = nil) {
        generator = g
        issuer = t
        user = u
        fontAwesome = f ?? t.closestBrand()
    }
    
    public convenience init?(_ keychainItem: [String: Any]) {
        guard let data = keychainItem["value"] as? String else {
            return nil
        }
        guard let url = URL(string: data) else { return nil }
        self.init(with: url)
    }
    
    public convenience init?(with url: URL) {
        do {
            guard
                let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
                let queryItems = components.queryItems,
                let type       = components.host
            else { throw TokenError.componentsNotDeserializable }
            
            guard components.scheme == "otpauth" else {
                throw TokenError.urlNotConformingToRFC
            }
            
            let issuer = try Token.parseTokenIssuer(with: queryItems, andLabel: components.path)
            let label  = Token.parseUser(with: components.path)
            
            let secret    = try Token.parseSecret(with: queryItems)
            let factor    = try Token.parseFactor(with: type, andItems: queryItems)
            let algorithm = try Token.parseAlgorithm(with: queryItems)
            let digits    = try Token.parseDigits(with: queryItems)
            
            let generator = Generator(secret: secret, moveFactor: factor, tokenAlgoritm: algorithm, digits: digits)
            
            let fontAwesome = try Token.parseFontAwesome(with: queryItems, issuer: issuer)
            
            self.init(generator: generator, tokenIssuer: issuer, user: label, fontAwesome: fontAwesome)
        } catch let error {
            print("LibToken token creation: \(error.localizedDescription)")
            return nil
        }
    }
    
    public func password(at time: Date = Date(), format: Bool = false) -> String {
        return generator.password(at: time, format: format)
    }
    
    public func timeRemaining(_ reversed: Bool = false) -> Float {
        let time = generator.moveFactor.timeRemaining(at: Date(), reversed)
        return time
    }
    
    public static func ==(l: Token, r: Token) -> Bool {
        return (l.issuer == r.issuer) &&
               (l.user == r.user) &&
               (l.generator == r.generator)
    }
    
    public func serialize() throws -> URL {
        var components: URLComponents = URLComponents()
        
        components.scheme = "otpauth"
        components.path = "/\(issuer):\(user)"
        
        let fastring = FontAwesomeBrands.filter { $0.value == self.fontAwesome.rawValue }.first!
        
        var items: [URLQueryItem] = [
            URLQueryItem(name: "secret", value: generator.secret.base32String()),
            URLQueryItem(name: "issuer", value: issuer),
            URLQueryItem(name: "algorithm", value: generator.algorithm.machineName),
            URLQueryItem(name: "digits", value: "\(generator.digits)"),
            URLQueryItem(name: "fa", value: fastring.key)
        ]
        
        switch generator.moveFactor {
        case .hotp(let interval):
            components.host = "hotp"
            items.append(URLQueryItem(name: "period", value: "\(Int(interval))"))
        case .totp(let interval):
            components.host = "totp"
            items.append(URLQueryItem(name: "period", value: "\(Int(interval))"))
        }
        
        components.queryItems = items
        
        guard let url = components.url else {
            throw TokenError.componentsNotSerializable
        }
        
        return url
    }
}
