//
//  Path+XCConfig.swift
//  ProjectDescriptionHelpers
//
//  Created by JunHyeok Lee on 3/19/24.
//

import ProjectDescription

extension Path {
    public struct XCConfig {
        public static func app(_ configuration: AppConfiguration) -> Path {
            return "//XCConfig/Application/Application-\(configuration.rawValue).xcconfig"
        }
        
        public static func xcconfig(_ configuration: AppConfiguration) -> Path {
            return "//XCConfig/\(configuration.rawValue).xcconfig"
        }
    }
}
