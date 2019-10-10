//
//  AttributtedText.swift
//  HouzzFix
//
//  Created by Mohd Maruf on 25/09/18.
//  Copyright © 2018 SK. All rights reserved.
//

import Foundation
import UIKit

public extension NSObject {
    
    public func underline(_ text: String, font: UIFont, color: UIColor) -> NSAttributedString {
        let attributedString = NSAttributedString(string: text, attributes: [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: color,
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.styleSingle.rawValue
            ])
        
        return attributedString
    }
    
    public func attributedColoredString(fullString: String, fullStringColor: UIColor, subString: String, subStringColor: UIColor) -> NSMutableAttributedString {
        let range = (fullString as NSString).range(of: subString)
        let attributedString = NSMutableAttributedString(string: fullString)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: fullStringColor, range: NSRange(location: 0, length: fullString.count))
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: subStringColor, range: range)
        
        return attributedString
    }
    
    public func attributedFontString(fullString: String, fullStringColor: UIColor, subString: String, subStringColor: UIColor, subStrinFont: UIFont = UIFont()) -> NSAttributedString {
        let range = (fullString as NSString).range(of: subString)
        let attributedString = NSMutableAttributedString(string: fullString)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: fullStringColor, range: NSRange(location: 0, length: fullString.count))
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: subStringColor, range: range)
        attributedString.addAttribute(NSAttributedString.Key.font, value: subStrinFont, range: range)
        
        return attributedString
    }
    
    func getAttributedStickString(_ string: String, _ textColor: UIColor = .white) -> NSAttributedString {
        return attributedColoredString(fullString: string + " *", fullStringColor: textColor, subString: "*", subStringColor: AppDelegate.shared.buttonColor)
    }
    
    func getAttributedCustomString(_ string: String, customString: String, _ textColor: UIColor = .lightGray, customTextColor: UIColor = .lightGray, customStringTextSize: CGFloat = 10) -> NSAttributedString {
         let attributedString = attributedColoredString(fullString: string + " *", fullStringColor: textColor, subString: "*", subStringColor: .red)
        let customAttribtedString = [NSAttributedString.Key.font: UIFont.italicSystemFont(ofSize: customStringTextSize), NSAttributedString.Key.foregroundColor: customTextColor]
    
        let finalCustomAttributedString = NSMutableAttributedString(string: customString, attributes: customAttribtedString)
        attributedString.append(finalCustomAttributedString)
        
        return attributedString
    }
}
