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
        public static let systemPink: UIColor = .systemPink
        public static let systemGreen: UIColor = .systemGreen
        public static let systemPurple: UIColor = .systemPurple
        
        public static let lightGreen: UIColor = .green // MARK: - e
        public static let wine: UIColor = .purple
        public static let turquoise: UIColor = .green
        public static let deepBlue: UIColor = .blue
        public static let darkBackground: UIColor = UIColor(hex: "2E2E2E") ?? .darkGray
        public static let dimBlack: UIColor = (UIColor(hex: "#22282A") ?? .black).withAlphaComponent(0.75)
        public static let kakaoYellow: UIColor = UIColor(hex: "#FDDC3F") ?? .systemYellow
        public static let googleBlue: UIColor = UIColor(hex: "#4285F4") ?? .systemBlue
        public static let background: UIColor = UIColor(named: "background") ?? UIColor()
        public static let buttonHighlightBlue: UIColor = UIColor(hex: "#0055AA") ?? .systemBlue
        public static let textFieldBackground: UIColor = UIColor(hex: "#DDDDDD") ?? .lightGray
    }
}
