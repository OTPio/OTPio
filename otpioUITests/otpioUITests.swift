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
        
        let app = XCUIApplication()
        let button = app.navigationBars["My Codes"].buttons[""]
        button.tap()
        
        let tablesQuery = app.tables
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Solarized Dark"]/*[[".cells.staticTexts[\"Solarized Dark\"]",".staticTexts[\"Solarized Dark\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let sheetsQuery = app.sheets
        sheetsQuery.buttons["Solarized Light"].tap()
        
        let saveButton = app.navigationBars["otpio.SettingsVC"].buttons["Save"]
        saveButton.tap()
        snapshot("THEME01-SolarizedLight")
        button.tap()
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Solarized Light"]/*[[".cells.staticTexts[\"Solarized Light\"]",".staticTexts[\"Solarized Light\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        sheetsQuery.buttons["Night/Light Dark"].tap()
        saveButton.tap()
        snapshot("THEME02-NightLightDark")
        button.tap()
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Night/Light Dark"]/*[[".cells.staticTexts[\"Night\/Light Dark\"]",".staticTexts[\"Night\/Light Dark\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        sheetsQuery.buttons["Night/Light Bright"].tap()
        saveButton.tap()
        snapshot("THEME03-NightLightBright")
        button.tap()
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Night/Light Bright"]/*[[".cells.staticTexts[\"Night\/Light Bright\"]",".staticTexts[\"Night\/Light Bright\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        sheetsQuery.buttons["Solarized Dark"].tap()
        saveButton.tap()
        snapshot("THEME04-SolarizedDark")
        tablesQuery.children(matching: .cell).element(boundBy: 0).staticTexts["Matrix Studios"].tap()
        snapshot("VIEW01-CodeDetails")
    }

}
