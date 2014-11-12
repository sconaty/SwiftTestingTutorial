//
//  Theme.swift
//  BDDExample
//
//  Created by Sheldon Conaty on 20/09/2014.
//  Copyright (c) 2014 Sheldon Conaty. All rights reserved.
//

import Foundation
import Cocoa

class Theme {
    // Constants (JSON key names) ------------------------------------------------------------------
    
    enum Keys: String {
        case Defaults = "defaults"
        case Paragraph = "paragraph"
        case Alignment = "alignment"
        case FirstLineHeadIndent = "firstLineHeadIndent"
        case HeadIndent = "headIndent"
        case TailIndent = "tailIndent"
        case LineBreakMode = "lineBreakMode"
        case MaximumLineHeight = "maximumLineHeight"
        case MinimumLineHeight = "minimumLineHeight"
        case LineHeightMultiple = "lineHeightMultiple"
        case LineSpacing = "lineSpacing"
        case ParagraphSpacing = "paragraphSpacing"
        case ParagraphSpacingBefore = "paragraphSpacingBefore"
        case WritingDirection = "writingDirection"
    }
    
    enum AlignmentValues: String {
        case Left = "left"
        case Center = "center"
        case Right = "right"
        case Justified = "justified"
        case Natural = "natural"
    }
    
    enum WrappingValues: String {
        case Word = "wordWrapping"
        case Character = "characterWrapping"
    }
    
    enum DirectionValues: String {
        case Natural = "natural"
        case LeftToRight = "leftToRight"
        case RightToLeft = "rightToLeft"
    }
    
    let defaultParagraphStyle: NSParagraphStyle!
    
    // Class level functions -----------------------------------------------------------------------
    
    class func loadFromFile(filePath: String) -> Theme? {
        let optionalJSONData = NSData(contentsOfFile: filePath)
        
        if let jsonData = optionalJSONData {
            return Theme(json: JSON(data:jsonData));
        } else {
            XCGLogger.error("Unable to load theme from file [\(filePath)]")
            return nil
        }
    }
    
    class func loadFromString(jsonString: String) -> Theme? {
        let optionalJsonData = (jsonString as NSString).dataUsingEncoding(NSUTF8StringEncoding)
        if (optionalJsonData == nil) {
            XCGLogger.error("Unable to create NSData from string \(jsonString)")
            return nil
        }
        
        let json = JSON(data:optionalJsonData!)
        
        if (json.type == .Null) {
            XCGLogger.error("Unable to parse JSON from string [\(jsonString)], [\(json.description)]")
            return nil
        }
        
        return Theme(json: json)
    }
    
    // Instance level functions --------------------------------------------------------------------
    
    init?(json: JSON) {
        let defaults = json[Keys.Defaults.rawValue]
        
        defaultParagraphStyle = buildParagraphStyleFrom(defaults[Keys.Paragraph.rawValue])
    }
    
    func buildParagraphStyleFrom(json: JSON) -> NSParagraphStyle {
        var paragraphStyle = NSMutableParagraphStyle()
        
        let optionalAlignment = json[Keys.Alignment.rawValue].string
        if let alignment = optionalAlignment {
            switch (alignment) {
            case AlignmentValues.Left.rawValue:
                paragraphStyle.alignment = .LeftTextAlignment
            case AlignmentValues.Center.rawValue:
                paragraphStyle.alignment = .CenterTextAlignment
            case AlignmentValues.Right.rawValue:
                paragraphStyle.alignment = .RightTextAlignment
            case AlignmentValues.Justified.rawValue:
                paragraphStyle.alignment = .JustifiedTextAlignment
            case AlignmentValues.Natural.rawValue:
                paragraphStyle.alignment = .NaturalTextAlignment
            default:
                XCGLogger.error("Unable to set paragraph alignment to unknown value [\(alignment)], assuming [\(AlignmentValues.Natural.rawValue)]")
                paragraphStyle.alignment = .NaturalTextAlignment
            }
        }

        let optionalFirstLineHeadIndent = json[Keys.FirstLineHeadIndent.rawValue].double
        if let firstLineheadIndent = optionalFirstLineHeadIndent {
            paragraphStyle.firstLineHeadIndent = CGFloat(firstLineheadIndent)
        }
        
        let optionalHeadIndent = json[Keys.HeadIndent.rawValue].double
        if let headIndent = optionalHeadIndent {
            paragraphStyle.headIndent = CGFloat(headIndent)
        }
        
        let optionalLineBreakMode = json[Keys.LineBreakMode.rawValue].string
        if let lineBreakMode = optionalLineBreakMode {
            switch (lineBreakMode) {
            case WrappingValues.Word.rawValue:
                paragraphStyle.lineBreakMode = .ByWordWrapping
            case WrappingValues.Character.rawValue:
                paragraphStyle.lineBreakMode = .ByCharWrapping
            default:
                XCGLogger.error("Unable to set paragraph line break mode to unknown value [\(lineBreakMode)], assuming [\(WrappingValues.Word.rawValue)]")
                paragraphStyle.lineBreakMode = .ByWordWrapping
            }
        }
        
        let optionalMaximumLineHeight = json[Keys.MaximumLineHeight.rawValue].double
        if let maximumLineHeight = optionalMaximumLineHeight {
            paragraphStyle.maximumLineHeight = max(CGFloat(maximumLineHeight), 0.0)
        }
        
        let optionalMinimumLineHeight = json[Keys.MinimumLineHeight.rawValue].double
        if let minimumLineHeight = optionalMinimumLineHeight {
            paragraphStyle.minimumLineHeight = max(CGFloat(minimumLineHeight), 0.0)
        }
        
        let optionalLineHeightMultiple = json[Keys.LineHeightMultiple.rawValue].double
        if let lineHeightMultiple = optionalLineHeightMultiple {
            paragraphStyle.lineHeightMultiple = max(CGFloat(lineHeightMultiple), 0.0)
        }
        
        let optionalLineSpacing = json[Keys.LineSpacing.rawValue].double
        if let lineSpacing = optionalLineSpacing {
            paragraphStyle.lineSpacing = max(CGFloat(lineSpacing), 0.0)
        }
        
        let optionalParagraphSpacing = json[Keys.ParagraphSpacing.rawValue].double
        if let paragraphSpacing = optionalParagraphSpacing {
            paragraphStyle.paragraphSpacing = max(CGFloat(paragraphSpacing), 0.0)
        }
        
        let optionalParagraphSpacingBefore = json[Keys.ParagraphSpacingBefore.rawValue].double
        if let paragraphSpacingBefore = optionalParagraphSpacingBefore {
            paragraphStyle.paragraphSpacingBefore = max(CGFloat(paragraphSpacingBefore), 0.0)
        }
        
        return paragraphStyle
    }
}
