//
//  RoutingOptions.swift
//  otpio
//
//  Created by Mason Phillips on 1/23/19.
//  Copyright © 2019 Matrix Studios. All rights reserved.
//

import Foundation
import LibFA

typealias MenuItem = (n: String, f: FontAwesome)

enum RouterOption: CaseIterable {
    case tokens, settings
    
    static let `default`: RouterOption = .tokens
    
    func menuItemForOption() -> MenuItem {
        switch self {
        case .tokens  : return ("My Tokens", .qrcode)
        case .settings: return ("Settings", .cogs)
        }
    }
    
    func controllerForOption() -> BaseUIC {
        switch self {
        case .tokens  : return UserTokensVC()
        case .settings: return BaseUIC()
        }
    }
}
