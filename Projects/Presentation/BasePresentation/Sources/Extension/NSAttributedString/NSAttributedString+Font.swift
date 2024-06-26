//
//  NSAttributedString+Font.swift
//  BasePresentation
//
//  Created by JunHyeok Lee on 3/26/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit

extension NSAttributedString {
    static func title(_ string: String,
                      color: UIColor,
                      alignment: NSTextAlignment = .left) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.paragraphSpacing = 1.5
        paragraphStyle.alignment = alignment
        let font = Constants.Font.suiteSemiBold(24.0)
        return NSAttributedString(string: string,
                                  attributes: [
                                    .paragraphStyle: paragraphStyle,
                                    .foregroundColor: color,
                                    .font: font,
                                    .kern: -0.25
                                  ])
    }
    
    static func message(_ string: String,
                        color: UIColor,
                        alignment: NSTextAlignment = .left) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.paragraphSpacing = 1.5
        paragraphStyle.alignment = alignment
        let font = Constants.Font.suiteSemiBold(18.0)
        return NSAttributedString(string: string,
                                  attributes: [
                                    .paragraphStyle: paragraphStyle,
                                    .foregroundColor: color,
                                    .font: font,
                                    .kern: -0.25
                                  ])
    }
    
    static func button(_ string: String,
                       color: UIColor,
                       alignment: NSTextAlignment = .left) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.paragraphSpacing = 1.5
        paragraphStyle.alignment = alignment
        let font = Constants.Font.suiteSemiBold(15.0)
        return NSAttributedString(string: string,
                                  attributes: [
                                    .paragraphStyle: paragraphStyle,
                                    .foregroundColor: color,
                                    .font: font,
                                    .kern: -0.25
                                  ])
    }
}
