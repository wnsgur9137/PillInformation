//
//  XCConfig.swift
//  ProjectDescriptionHelpers
//
//  Created by JUNHYEOK LEE on 1/22/24.
//

import Foundation
import ProjectDescription

public struct XCConfig { }

public extension XCConfig {
    enum Application {
        public static func app(_ configuration: AppConfiguration) -> Path {
            "//XCConfig/Application/Application-\(configuration.rawValue).xcconfig"
        }
        public static func devApp(_ configuration: AppConfiguration) -> Path {
            "//XCConfig/Application/Application-\(configuration.rawValue).xcconfig"
        }
    }
}
