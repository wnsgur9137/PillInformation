//
//  AppConfiguration.swift
//  MyPlugin
//
//  Created by JunHyeok Lee on 1/22/24.
//

import Foundation
import ProjectDescription

public enum AppConfiguration: String {
    case dev = "DEV"
    case test = "TEST"
    case prod = "PROD"
    case shared
    
    public var configurationName: ConfigurationName {
        .configuration(rawValue)
    }
}

public extension String {
    static var dev: String { AppConfiguration.dev.rawValue }
    static var test: String { AppConfiguration.test.rawValue }
    static var prod: String { AppConfiguration.prod.rawValue }
    static var shared: String { AppConfiguration.shared.rawValue }
}

public extension ConfigurationName {
    static var dev: ConfigurationName { AppConfiguration.dev.configurationName }
    static var test: ConfigurationName { AppConfiguration.test.configurationName }
    static var prod: ConfigurationName { AppConfiguration.prod.configurationName }
}
