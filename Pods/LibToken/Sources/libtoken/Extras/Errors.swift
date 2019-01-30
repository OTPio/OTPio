//
//  Errors.swift
//  libtoken
//
//  Created by Mason Phillips on 11/18/18.
//

import Foundation

public enum TokenError: Error {
    // Deserialization
    case componentsNotDeserializable
    case urlNotConformingToRFC
    case secretNotFound
    case issuerNotFound
    case moveFactorTypeNotFound
    case hotpFactorNotParsable
    case algorithmNotParsable
    case digitsNotParsable
    case fontAwesomeNotParsable
    
    // Serialization
    case componentsNotSerializable
    case urlNotConvertedToData
    
    public var localizedDescription: String {
        switch self {
        case .componentsNotDeserializable: return "The URL could not be serialized into components"
        case .urlNotConformingToRFC      : return "The URL does not conform to RFC. Missing otpauth:// scheme"
        case .secretNotFound             : return "Could not find a secret in the URL"
        case .issuerNotFound             : return "Could not find an issuer in the URL"
        case .moveFactorTypeNotFound     : return "Could not find a type (H/TOTP)"
        case .hotpFactorNotParsable      : return "Could not parse the counter"
        case .algorithmNotParsable       : return "Could not parse the algorithm"
        case .digitsNotParsable          : return "Could not parse the number of digits to use"
        case .fontAwesomeNotParsable     : return "Could not parse the requested FontAwesome icon"
            
        case .componentsNotSerializable  : return "The components could not be serialized into a URL"
            
        default: return "An unhandled exception occured"
        }
    }
}
