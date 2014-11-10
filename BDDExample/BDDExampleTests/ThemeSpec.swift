//
//  ThemeSpec.swift
//  BDDExample
//
//  Created by Sheldon Conaty on 05/10/2014.
//  Copyright (c) 2014 Sheldon Conaty. All rights reserved.
//

import Cocoa
import Quick
import Nimble


class ThemeSpec: QuickSpec {
    // MARK: Test Aids
    func createThemeWithSilentLogging(creationFunc: () -> Theme?) -> Theme? {
        let defaultLogLevel = XCGLogger.defaultInstance().outputLogLevel
        XCGLogger.defaultInstance().outputLogLevel = XCGLogger.LogLevel.None
        
        var optionalTheme = creationFunc()
        
        XCGLogger.defaultInstance().outputLogLevel = defaultLogLevel
        return optionalTheme
    }
    
    override func spec() {
        describe("Theme") {
            
            // MARK: - Creation
            context("being created") {
                describe("from valid") {
                    let json = JSON([
                        "defaults": [
                            "paragraph":
                                ["alignment": "left"]
                        ]
                    ])
                    
                    func validateTheme(optionalTheme: Theme?) {
                        expect(optionalTheme).toNot(beNil())
                        expect(optionalTheme!.defaultParagraphStyle.alignment).to(equal(NSTextAlignment.LeftTextAlignment))
                    }
                    
                    it("string should load succesfully") {
                        let optionalTheme = Theme.loadFromString(json.description)
                        validateTheme(optionalTheme)
                    }
                    
                    it("SwiftyJSON should load successfully") {
                        let optionalTheme = Theme.init(json: json)
                        validateTheme(optionalTheme)
                    }
                    
                    it("file should load successfully") {
                        let filePath = NSBundle(forClass:ThemeSpec.self).pathForResource("ValidTheme", ofType: "json")!
                        let optionalTheme = Theme.loadFromFile(filePath)
                        validateTheme(optionalTheme)
                    }
                }
                
                describe("from invalid") {
                    it ("string should fail to load") {
                        let badJsonString = "badName:badValue"
                        let optionalTheme = self.createThemeWithSilentLogging() {
                            Theme.loadFromString(badJsonString)
                        }
                        
                        expect(optionalTheme).to(beNil())
                    }
                }
            }   // Creation
            
            // MARK: - Paragraph Validation
            context("paragraph validation of") {
                func sampleJSON(userValues: [String: AnyObject]) -> JSON {
                    let defaultValues = [
                        "alignment": "left",
                        "firstLineHeadIndent": 0,
                        "headIndent": 0,
                        "tailIndent": 0,
                        "lineBreakMode": "wordWrapping",
                        "maximumLineHeight": 10,
                        "minimumLineHeight": 10,
                        "lineHeightMultiple": 2,
                        "lineSpacing": 12,
                        "paragraphSpacing": 24,
                        "paragraphSpacingBefore": 32,
                        "writingDirection": "natural"
                    ]
                    var values = defaultValues + userValues
                    
                    return JSON([
                        "defaults": [
                            "paragraph": [
                                "alignment": values["alignment"]!,
                                "firstLineHeadIndent": values["firstLineHeadIndent"]!,
                                "headIndent": values["headIndent"]!,
                                "tailIndent": values["tailIndent"]!,
                                "lineBreakMode": values["lineBreakMode"]!,
                                "maximumLineHeight": values["maximumLineHeight"]!,
                                "minimumLineHeight": values["minimumLineHeight"]!,
                                "lineHeightMultiple": values["lineHeightMultiple"]!,
                                "lineSpacing": values["lineSpacing"]!,
                                "paragraphSpacing": values["paragraphSpacing"]!,
                                "paragraphSpacingBefore": values["paragraphSpacingBefore"]!,
                                "writingDirection": values["writingDirection"]!,
                            ]
                        ]
                        ])
                }
                
                describe("alignment") {
                    let validAlignments = [
                        "left": NSTextAlignment.LeftTextAlignment,
                        "center": NSTextAlignment.CenterTextAlignment,
                        "right": NSTextAlignment.RightTextAlignment,
                        "justified": NSTextAlignment.JustifiedTextAlignment,
                        "natural": NSTextAlignment.NaturalTextAlignment
                    ]
                    
                    for (inputValue, expectedOutput) in validAlignments {
                        it("should support \(inputValue) alignment") {
                            let theme = Theme.init(json: sampleJSON(["alignment": inputValue]))!
                            expect(theme.defaultParagraphStyle.alignment).to(equal(expectedOutput))
                        }
                    }
                    
                    let invalidAlignments = [
                        "badValue": "invalid string",
                        12.3: "invalid type"
                    ]
                    
                    for (inputValue, typeDescription) in invalidAlignments {
                        it("should default to natural for \(typeDescription)") {
                            let theme = self.createThemeWithSilentLogging() {
                                Theme.init(json: sampleJSON(["alignment": inputValue]))
                            }!
                            
                            expect(theme.defaultParagraphStyle.alignment).to(equal(NSTextAlignment.NaturalTextAlignment))
                        }
                    }
                }
                
                describe("first line head indent") {
                    it("should support floats") {
                        let theme = Theme.init(json: sampleJSON(["firstLineHeadIndent": 12.3]))!
                        expect(theme.defaultParagraphStyle.firstLineHeadIndent).to(equal(12.3))
                    }
                    
                    it("should default to 0.0 for invalid type") {
                        let theme = Theme.init(json: sampleJSON(["firstLineHeadIndent": "badValue"]))!
                        expect(theme.defaultParagraphStyle.firstLineHeadIndent).to(equal(0))
                    }
                }
                
                describe("head indent") {
                    it("should support floats") {
                        let theme = Theme.init(json: sampleJSON(["headIndent": 1.0]))!
                        expect(theme.defaultParagraphStyle.headIndent).to(equal(1.0))
                    }
                    
                    it("should default to 0.0 for invalid type") {
                        let theme = Theme.init(json: sampleJSON(["headIndent": "badValue"]))!
                        expect(theme.defaultParagraphStyle.headIndent).to(equal(0))
                    }
                }
                
                describe("tail indent") {
                    it("should support floats") {
                        let theme = Theme.init(json: sampleJSON(["tailIndent": 0.25]))!
                        expect(theme.defaultParagraphStyle.tailIndent).to(equal(0.25))
                    }
                    
                    it("should default to 0.0 for invalid type") {
                        let theme = Theme.init(json: sampleJSON(["tailIndent": "badValue"]))!
                        expect(theme.defaultParagraphStyle.tailIndent).to(equal(0))
                    }
                }
                
                describe("line break mode") {
                    let validModes = [
                        "wordWrapping": NSLineBreakMode.ByWordWrapping,
                        "characterWrapping": NSLineBreakMode.ByCharWrapping
                    ]
                    
                    for (inputValue, expectedOutput) in validModes {
                        it("should support \(inputValue) line break mode") {
                            let theme = Theme.init(json: sampleJSON(["lineBreakMode": inputValue]))!
                            expect(theme.defaultParagraphStyle.lineBreakMode).to(equal(expectedOutput))
                        }
                    }
                    
                    let invalidModes = [
                        "badValue": "invalid string",
                        12.3: "invalid type"
                    ]
                    
                    for (inputValue, typeDescription) in invalidModes {
                        it("should default to wordWrapping for \(typeDescription)") {
                            let theme = self.createThemeWithSilentLogging() {
                                Theme.init(json: sampleJSON(["lineBreakMode": inputValue]))
                            }!
                            
                            expect(theme.defaultParagraphStyle.lineBreakMode).to(equal(NSLineBreakMode.ByWordWrapping))
                        }
                    }
                    
                }
                
                describe("maximum line height") {
                    it("should support floats") {
                        let theme = Theme.init(json: sampleJSON(["maximumLineHeight": 78.9]))!
                        expect(theme.defaultParagraphStyle.maximumLineHeight).to(equal(78.9))
                    }
                    
                    let invalidAlignments = [
                        "badValue": "invalid type",
                        -12.3: "invalid negative value"
                    ]
                    
                    for (inputValue, typeDescription) in invalidAlignments {
                        it("should default to 0.0 for \(typeDescription)") {
                            let theme = Theme.init(json: sampleJSON(["maximumLineHeight": inputValue]))!
                            expect(theme.defaultParagraphStyle.maximumLineHeight).to(equal(0))
                        }
                    }
                }
                
                describe("minimum line height") {
                    it("should support floats") {
                        let theme = Theme.init(json: sampleJSON(["minimumLineHeight": 12.3]))!
                        expect(theme.defaultParagraphStyle.minimumLineHeight).to(equal(12.3))
                    }
                    
                    let invalidAlignments = [
                        "badValue": "invalid type",
                        -12.3: "invalid negative value"
                    ]
                    
                    for (inputValue, typeDescription) in invalidAlignments {
                        it("should default to 0.0 for \(typeDescription)") {
                            let theme = Theme.init(json: sampleJSON(["minimumLineHeight": inputValue]))!
                            expect(theme.defaultParagraphStyle.minimumLineHeight).to(equal(0))
                        }
                    }
                }
                
                describe("line height multiple") {
                    it("should support floats") {
                        let theme = Theme.init(json: sampleJSON(["lineHeightMultiple": 0.5]))!
                        expect(theme.defaultParagraphStyle.lineHeightMultiple).to(equal(0.5))
                    }
                    
                    let invalidAlignments = [
                        "badValue": "invalid type",
                        -0.5: "invalid negative value"
                    ]
                    
                    for (inputValue, typeDescription) in invalidAlignments {
                        it("should default to 0.0 for \(typeDescription)") {
                            let theme = Theme.init(json: sampleJSON(["lineHeightMultiple": inputValue]))!
                            expect(theme.defaultParagraphStyle.lineHeightMultiple).to(equal(0))
                        }
                    }
                }
                
                describe("line spacing") {
                    it("should support floats") {
                        let theme = Theme.init(json: sampleJSON(["lineSpacing": 0.25]))!
                        expect(theme.defaultParagraphStyle.lineSpacing).to(equal(0.25))
                    }
                    
                    let invalidAlignments = [
                        "badValue": "invalid type",
                        -0.5: "invalid negative value"
                    ]
                    
                    for (inputValue, typeDescription) in invalidAlignments {
                        it("should default to 0.0 for \(typeDescription)") {
                            let theme = Theme.init(json: sampleJSON(["lineSpacing": inputValue]))!
                            expect(theme.defaultParagraphStyle.lineSpacing).to(equal(0))
                        }
                    }
                }
                
                describe("paragraph spacing") {
                    it("should support floats") {
                        let theme = Theme.init(json: sampleJSON(["paragraphSpacing": 1.25]))!
                        expect(theme.defaultParagraphStyle.paragraphSpacing).to(equal(1.25))
                    }
                    
                    let invalidAlignments = [
                        "badValue": "invalid type",
                        -0.5: "invalid negative value"
                    ]
                    
                    for (inputValue, typeDescription) in invalidAlignments {
                        it("should default to 0.0 for \(typeDescription)") {
                            let theme = Theme.init(json: sampleJSON(["paragraphSpacing": inputValue]))!
                            expect(theme.defaultParagraphStyle.paragraphSpacing).to(equal(0))
                        }
                    }
                }
                
                describe("paragraph spacing before") {
                    it("should support floats") {
                        let theme = Theme.init(json: sampleJSON(["paragraphSpacingBefore": 0.2]))!
                        expect(theme.defaultParagraphStyle.paragraphSpacingBefore).to(equal(0.2))
                    }
                    
                    let invalidAlignments = [
                        "badValue": "invalid type",
                        -0.5: "invalid negative value"
                    ]
                    
                    for (inputValue, typeDescription) in invalidAlignments {
                        it("should default to 0.0 for \(typeDescription)") {
                            let theme = Theme.init(json: sampleJSON(["paragraphSpacingBefore": inputValue]))!
                            expect(theme.defaultParagraphStyle.paragraphSpacingBefore).to(equal(0))
                        }
                    }
                }
                
                describe("writing direction") {
                    let validDirections = [
                        "natural": NSWritingDirection.Natural,
                        "leftToRight": NSWritingDirection.LeftToRight,
                        "rightToLeft": NSWritingDirection.RightToLeft
                    ]
                    
                    for (inputValue, expectedOutput) in validDirections {
                        it("should support \(inputValue) direction") {
                            let theme = Theme.init(json: sampleJSON(["writingDirection": inputValue]))!
                            expect(theme.defaultParagraphStyle.baseWritingDirection).to(equal(expectedOutput))
                        }
                    }
                    
                    let invalidDirections = [
                        "badValue": "invalid string",
                        4.5: "invalid type"
                    ]
                    
                    for (inputValue, typeDescription) in invalidDirections {
                        it("should default to natural for \(typeDescription)") {
                            let theme = self.createThemeWithSilentLogging() {
                                Theme.init(json: sampleJSON(["writingDirection": inputValue]))
                            }!
                            
                            expect(theme.defaultParagraphStyle.baseWritingDirection).to(equal(NSWritingDirection.Natural))
                        }
                    }
                }
            }   // Validation

        }
    }
}
