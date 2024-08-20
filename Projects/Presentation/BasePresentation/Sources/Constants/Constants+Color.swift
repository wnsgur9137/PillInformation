//
//  Constants+Color.swift
//  Common
//
//  Created by JUNHYEOK LEE on 2/5/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit

extension Constants {
    // MARK: - Color
    public struct Color {
        public static let clear: UIColor = .clear
        public static let systemBlack: UIColor = .black
        public static let systemWhite: UIColor = .white
        public static let systemLabel: UIColor = .label
        public static let systemBackground: UIColor = .systemBackground
        public static let systemRed: UIColor = .systemRed
        public static let systemBlue: UIColor = .systemBlue
        public static let systemGray: UIColor = .gray
        public static let systemLightGray: UIColor = .lightGray
        public static let systemDarkGray: UIColor = .darkGray
        public static let systemYellow: UIColor = .systemYellow
        public static let systemBrown: UIColor = .systemBrown
        public static let systemOrange: UIColor = .systemOrange
        public static let systemGreen: UIColor = .systemGreen
        public static let systemPurple: UIColor = .systemPurple
        
        public static let pink: UIColor = .init(hex: "#FFC0CB") ?? .init()
        public static let lightGreen: UIColor = .green // MARK: - e
        public static let wine: UIColor = .init(hex: "#800080") ?? UIColor()
        public static let turquoise: UIColor = .init(hex: "#40E0D0") ?? UIColor()
        public static let deepBlue: UIColor = .init(hex: "#00008B") ?? UIColor()
        public static let darkBackground: UIColor = UIColor(hex: "2E2E2E") ?? .darkGray
        public static let dimBlack: UIColor = (UIColor(hex: "#22282A") ?? .black).withAlphaComponent(0.75)
        public static let kakaoYellow: UIColor = UIColor(hex: "#FDDC3F") ?? .systemYellow
        public static let googleBlue: UIColor = UIColor(hex: "#4285F4") ?? .systemBlue
        public static let background: UIColor = UIColor(named: "background") ?? UIColor()
        public static let buttonHighlightBlue: UIColor = UIColor(hex: "#0055AA") ?? .systemBlue
        public static let textFieldBackground: UIColor = UIColor(hex: "#DDDDDD") ?? .lightGray
        
        public static let skyBlueBackground: UIColor = {
            return UIColor { (traits) -> UIColor in
                if traits.userInterfaceStyle == .dark {
                    return UIColor(hex: "#2A3B47") ?? .systemBlue
                }
                return UIColor(hex: "#E6F2FF") ?? .systemBlue
            }
        }()
        
        public static let label: UIColor = {
            return UIColor { (traits) -> UIColor in
                if traits.userInterfaceStyle == .dark {
                    return systemWhite
                }
                return UIColor(hex: "#394346") ?? systemLabel
            }
        }()
    }
}

//MARK: -- Gray Scale
extension Constants.Color {
    public static let gray950: UIColor = UIColor(hex: "#101010") ?? UIColor()
    public static let gray900: UIColor = UIColor(hex: "#22282A") ?? UIColor()
    public static let gray800: UIColor = UIColor(hex: "#394346") ?? UIColor()
    public static let gray750: UIColor = UIColor(hex: "#475357") ?? UIColor()
    public static let gray700: UIColor = UIColor(hex: "#5C6B70") ?? UIColor()
    public static let gray650: UIColor = UIColor(hex: "#728388") ?? UIColor()
    public static let gray600: UIColor = UIColor(hex: "#819298") ?? UIColor()
    public static let gray500: UIColor = UIColor(hex: "#ABB6BA") ?? UIColor()
    public static let gray400: UIColor = UIColor(hex: "#BDC6C0") ?? UIColor()
    public static let gray300: UIColor = UIColor(hex: "#CFD5D8") ?? UIColor()
    public static let gray200: UIColor = UIColor(hex: "#E6EAEB") ?? UIColor()
    public static let gray100: UIColor = UIColor(hex: "#F2F4F5") ?? UIColor()
    public static let gray50: UIColor = UIColor(hex: "#F9FAFA") ?? UIColor()
}
