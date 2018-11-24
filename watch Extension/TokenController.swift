//
//  TokenController.swift
//  watch Extension
//
//  Created by Mason Phillips on 11/15/18.
//  Copyright © 2018 Matrix Studios. All rights reserved.
//

import WatchKit
import Foundation
import KeychainAccess

class TokenController: WKInterfaceController {
    
    @IBOutlet weak var tokenTable: WKInterfaceTable!

    let keychain: Keychain     = Keychain(service: "com.otpio.token", accessGroup: "6S4L29QT59.com.otpio.fullkeychain").accessibility(.always)
    var tokens  : Array<Token> = []
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)

        let raw = self.keychain.allItems()
        let ts = raw.compactMap({ (input) -> Token? in
            guard let tUrl: String = input["value"] as? String else { return nil }
            guard let url: URL = URL(string: tUrl) else { return nil }
            
            return Token(from: url)
        })
        
        let count = ts.count
        self.tokens = ts
        tokenTable.setNumberOfRows(count, withRowType: "TokenRow")
    }
}
