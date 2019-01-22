//
//  Errors.swift
//  libtoken
//
//  Created by Mason Phillips on 11/18/18.
//

import Foundation

enum Deserialization: Error {
    case queryItemsNotFound
    case secretNotFound, secretInvalid
    case issuerNotFound
    case digitsLengthInvalid, pathInvalid
}
