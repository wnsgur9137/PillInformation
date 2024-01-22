//
//  AppConfiguration.swift
//  ProjectDescriptionHelpers
//
//  Created by JUNHYEOK LEE on 1/22/24.
//

import Foundation
import ProjectDescription

public enum AppConfiguration: String {
    case dev = "DEV"
    case test = "TEST"
    case release = "RELEASE"
    
    public var configurationName: ConfigurationName {
        .configuration(rawValue)
    }
}

public extension String {
    static var dev: String { AppConfiguration.dev.rawValue }
    static var test: String { AppConfiguration.test.rawValue }
    static var release: String { AppConfiguration.release.rawValue }
}

public extension ConfigurationName {
    static var dev: ConfigurationName { AppConfiguration.dev.configurationName }
    static var test: ConfigurationName { AppConfiguration.test.configurationName }
    static var release: ConfigurationName { AppConfiguration.release.configurationName }
}
