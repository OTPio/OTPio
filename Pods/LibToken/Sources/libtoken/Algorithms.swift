//
//  Algorithms.swift
//  libtoken
//
//  Created by Mason Phillips on 11/18/18.
//

import Foundation
import CommonCrypto

public enum TokenAlgorithm {
    case md5, sha1, sha224, sha256, sha384, sha512
    
    public func algorithmName(dash: Bool = false) -> String {
        let v: String
        switch self {
        case .md5   : v = "MD5"
        case .sha1  : v = "SHA-1"
        case .sha224: v = "SHA-224"
        case .sha256: v = "SHA-256"
        case .sha384: v = "SHA-384"
        case .sha512: v = "SHA-512"
        }
        
        return (dash) ? v : v.replacingOccurrences(of: "-", with: "")
    }
    
    internal func algorithmDetails() -> (CCHmacAlgorithm, Int32) {
        switch self {
        case .md5   : return (CCHmacAlgorithm(kCCHmacAlgMD5)   , CC_MD5_DIGEST_LENGTH)
        case .sha1  : return (CCHmacAlgorithm(kCCHmacAlgSHA1)  , CC_SHA1_DIGEST_LENGTH)
        case .sha224: return (CCHmacAlgorithm(kCCHmacAlgSHA224), CC_SHA224_DIGEST_LENGTH)
        case .sha256: return (CCHmacAlgorithm(kCCHmacAlgSHA256), CC_SHA256_DIGEST_LENGTH)
        case .sha384: return (CCHmacAlgorithm(kCCHmacAlgSHA384), CC_SHA384_DIGEST_LENGTH)
        case .sha512: return (CCHmacAlgorithm(kCCHmacAlgSHA512), CC_SHA512_DIGEST_LENGTH)
        }
    }
    
    public init(rawValue: String) {
        let mv = rawValue.replacingOccurrences(of: "-", with: "")
        
        switch mv.lowercased() {
        case "md5"   : self = .md5
        case "sha1"  : self = .sha1
        case "sha224": self = .sha224
        case "sha256": self = .sha256
        case "sha384": self = .sha384
        case "sha512": self = .sha512
            
        default: self = .sha1
        }
    }
}
