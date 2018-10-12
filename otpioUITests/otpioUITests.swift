//
//  otpioUITests.swift
//  otpioUITests
//
//  Created by Mason Phillips on 10/12/18.
//  Copyright © 2018 Matrix Studios. All rights reserved.
//

import XCTest
import OneTimePassword

class otpioUITests: XCTestCase {
    
    var keychain: Keychain?
    var currentTokens: Array<Token>!
    
    var testURL: URL = URL(string: "otpauth://totp/Hello?secret=asdfasdfasdfasdf&issuer=MatrixStudios")!

    override func setUp() {
        keychain = Keychain.sharedInstance
        
        continueAfterFailure = false
        XCUIApplication().launch()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        
        do {
            guard let c = try keychain?.allPersistentTokens() else { throw Keychain.Error.tokenSerializationFailure }
            
            currentTokens = []
            for t in c {
                currentTokens.append(t.token)
            }
        } catch let e {
            XCTFail("Could not retrieve keychain: \(e)")
        }
    }

    func testAddDeleteToken() {
        XCUIDevice.shared.orientation = .portrait
        
        let app = XCUIApplication()
        app.navigationBars["My Codes"].buttons[""].tap()
        app/*@START_MENU_TOKEN@*/.textFields["OTP URL"]/*[[".otherElements[\"SCLAlertView\"].textFields[\"OTP URL\"]",".textFields[\"OTP URL\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        app.textFields["OTP URL"].typeText(testURL.absoluteString)
        
        app/*@START_MENU_TOKEN@*/.buttons["Use OTP URL"]/*[[".otherElements[\"SCLAlertView\"].buttons[\"Use OTP URL\"]",".buttons[\"Use OTP URL\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        _ = app.waitForExistence(timeout: 5)
        
        let tablesQuery = XCUIApplication().tables
        tablesQuery/*@START_MENU_TOKEN@*/.cells.containing(.staticText, identifier:"Hello").element/*[[".cells.containing(.staticText, identifier:\"MatrixStudios\").element",".cells.containing(.staticText, identifier:\"Hello\").element"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeLeft()
    }
}
