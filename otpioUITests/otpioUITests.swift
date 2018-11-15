//
//  otpioUITests.swift
//  otpioUITests
//
//  Created by Mason Phillips on 11/15/18.
//  Copyright © 2018 Matrix Studios. All rights reserved.
//

import XCTest

class otpioUITests: XCTestCase {

    override func setUp() {
        continueAfterFailure = false

        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        snapshot("01CodesView")
        XCUIApplication().tables/*@START_MENU_TOKEN@*/.staticTexts["Matrix Studios"]/*[[".cells.staticTexts[\"Matrix Studios\"]",".staticTexts[\"Matrix Studios\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()        
        snapshot("02CodeDetails")
    }

}
