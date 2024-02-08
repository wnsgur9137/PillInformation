//
//  Constants.swift
//  Common
//
//  Created by JunHyeok Lee on 2/1/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit

public enum SuiteFont: String {
    case bold = "SUITE-Bold"
    case extraBold = "SUITE-ExtraBold"
    case semiBold = "SUITE-SemiBold"
    case heavy = "SUITE-Heavy"
    case medium = "SUITE-Medium"
    case regular = "SUITE-Regular"
    case light = "SUITE-Light"
}

extension Constants {
    // MARK: - Font
    public struct Font {
        public static func suiteBold(_ size: CGFloat) -> UIFont {
            return .init(name: SuiteFont.bold.rawValue, size: size) ?? .systemFont(ofSize: size, weight: .bold)
        }
        public static func suiteExtraBold(_ size: CGFloat) -> UIFont {
            return .init(name: SuiteFont.extraBold.rawValue, size: size) ?? .systemFont(ofSize: size, weight: .bold)
        }
        public static func suiteSemiBold(_ size: CGFloat) -> UIFont {
            return .init(name: SuiteFont.semiBold.rawValue, size: size) ?? .systemFont(ofSize: size, weight: .semibold)
        }
        public static func suiteHeavy(_ size: CGFloat) -> UIFont {
            return .init(name: SuiteFont.heavy.rawValue, size: size) ?? .systemFont(ofSize: size, weight: .heavy)
        }
        public static func suiteMedium(_ size: CGFloat) -> UIFont {
            return .init(name: SuiteFont.medium.rawValue, size: size) ?? .systemFont(ofSize: size, weight: .medium)
        }
        public static func suiteRegular(_ size: CGFloat) -> UIFont {
            return .init(name: SuiteFont.regular.rawValue, size: size) ?? .systemFont(ofSize: size, weight: .regular)
        }
        public static func suiteLight(_ size: CGFloat) -> UIFont {
            return .init(name: SuiteFont.light.rawValue, size: size) ?? .systemFont(ofSize: size, weight: .light)
        }
        
        public static let button1: UIFont = .init(name: SuiteFont.semiBold.rawValue, size: 17.0) ?? .systemFont(ofSize: 17.0, weight: .semibold)
        public static let button2: UIFont = .init(name: SuiteFont.semiBold.rawValue, size: 13.0) ?? .systemFont(ofSize: 13.0, weight: .semibold)
        public static let button3: UIFont = .init(name: SuiteFont.medium.rawValue, size: 13.0) ?? .systemFont(ofSize: 13.0, weight: .medium)
        
//        public static let headlineBold1: UIFont = .systemFont(ofSize: 35.0, weight: .bold)
//        public static let headlineBold2: UIFont = .systemFont(ofSize: 30.0, weight: .bold)
//        public static let headlineBold3: UIFont = .systemFont(ofSize: 24.0, weight: .bold)
//        public static let headlineSemibold1: UIFont = .systemFont(ofSize: 28.0, weight: .semibold)
//        public static let headlineSemibold2: UIFont = .systemFont(ofSize: 22.0, weight: .semibold)
//        
//        public static let subtitleBold1: UIFont = .systemFont(ofSize: 18.0, weight: .bold)
//        public static let subtitleBold2: UIFont = .systemFont(ofSize: 16.0, weight: .bold)
//        public static let subtitleSemiBold1: UIFont = .systemFont(ofSize: 26.0, weight: .semibold)
//        public static let subtitleSemiBold2: UIFont = .systemFont(ofSize: 20.0, weight: .semibold)
//        public static let subtitleSemiBold3: UIFont = .systemFont(ofSize: 18.0, weight: .semibold)
//        public static let subtitleSemiBold4: UIFont = .systemFont(ofSize: 15.0, weight: .semibold)
//        
//        public static let body1: UIFont = .systemFont(ofSize: 20.0, weight: .medium)
//        public static let body2: UIFont = .systemFont(ofSize: 18.0, weight: .medium)
//        public static let body3: UIFont = .systemFont(ofSize: 17.0, weight: .medium)
//        public static let body4: UIFont = .systemFont(ofSize: 15.0, weight: .medium)
//        public static let body5: UIFont = .systemFont(ofSize: 18.0, weight: .regular)
//        public static let body6: UIFont = .systemFont(ofSize: 17.0, weight: .regular)
//        
//        public static let captionSemibold1: UIFont = .systemFont(ofSize: 14.0, weight: .semibold)
//        public static let captionSemibold2: UIFont = .systemFont(ofSize: 12.0, weight: .semibold)
//        public static let captionMedium1: UIFont = .systemFont(ofSize: 13.0, weight: .medium)
//        public static let captionRegular1: UIFont = .systemFont(ofSize: 15.0, weight: .regular)
//        public static let captionRegular2: UIFont = .systemFont(ofSize: 14.0, weight: .regular)
//        public static let captionRegular3: UIFont = .systemFont(ofSize: 13.0, weight: .regular)
//        public static let captionRegular4: UIFont = .systemFont(ofSize: 12.0, weight: .regular)
    }
}
