//
//  ThemeTests.swift
//  UnitTestingExample
//
//  Created by Sheldon Conaty on 21/09/2014.
//  Copyright (c) 2014 Sheldon Conaty. All rights reserved.
//

import Cocoa
import XCTest

class ThemeTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    //- Test Creation ------------------------------------------------------------------------------
    
    func testThemeCreationFromJSONString() {
        let json = JSON([
            "defaults": [
                "paragraph":
                    ["alignment": "left"]
            ]
        ])
        
        let optionalTheme = Theme.loadFromString(json.description)
        
        XCTAssertNotNil(optionalTheme, "Theme was not created")
        XCTAssertEqual(optionalTheme!.defaultParagraphStyle.alignment, NSTextAlignment.LeftTextAlignment, "Paragraph is not left aligned")
    }
    
    func testThemeCreationFromSwiftyJSON() {
        let json = JSON([
            "defaults": [
                "paragraph":
                    ["alignment": "left"]
            ]
        ])
        
        let optionalTheme = Theme.init(json: json)
        
        XCTAssertNotNil(optionalTheme, "Theme was not created")
        XCTAssertEqual(optionalTheme!.defaultParagraphStyle.alignment, NSTextAlignment.LeftTextAlignment, "Paragraph is not left aligned")
    }
    
    func testThemeCreationFromInvalidJSONString() {
        let badJson = "badName:badValue"
        
        let optionalTheme = Theme.loadFromString(badJson)
        
        XCTAssertNil(optionalTheme, "Theme should not have been created")
    }
    
}
