//
//  otpioTests.swift
//  otpioTests
//
//  Created by Mason Phillips on 2/10/19.
//  Copyright © 2019 Matrix Studios. All rights reserved.
//

import XCTest
import FontBlaster
@testable import otpio

class otpioTests: XCTestCase {

    override func setUp() {
        
    }

    override func tearDown() {
        
    }

    func testFonts() {
        let expectation = self.expectation(description: "Should blast 4 fonts")
        
        FontBlaster.blast { fonts in
            XCTAssert(fonts.count == 4)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.1)
    }
}
