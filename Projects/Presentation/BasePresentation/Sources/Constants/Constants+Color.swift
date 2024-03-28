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
        public static let systemBlack: UIColor = .black
        public static let systemWhite: UIColor = .white
        public static let systemLabel: UIColor = .label
        public static let systemBackground: UIColor = .systemBackground
        public static let systemRed: UIColor = .systemRed
        public static let systemBlue: UIColor = .systemBlue
        public static let systemGray: UIColor = .gray
        public static let systemLightGray: UIColor = .lightGray
        public static let systemDarkGray: UIColor = .darkGray
        public static let darkBackground: UIColor = UIColor(hex: "2E2E2E") ?? .darkGray
        public static let dimBlack: UIColor = (UIColor(hex: "#22282A") ?? .black).withAlphaComponent(0.75)
        public static let kakaoYellow: UIColor = UIColor(hex: "#FEE500") ?? .systemYellow
        public static let googleBlue: UIColor = UIColor(hex: "#4285F4") ?? .systemBlue
    }
}
