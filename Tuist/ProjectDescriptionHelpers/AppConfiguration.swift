//
//  AppConfiguration.swift
//  ProjectDescriptionHelpers
//
//  Created by JunHyeok Lee on 3/19/24.
//

import ProjectDescription

public enum AppConfiguration: String {
    case DEV
    case TEST_DEV
    case TEST_PROD
    case PROD
    case SHARED
    
    public var configurationName: ConfigurationName {
        .configuration(rawValue)
    }
}

public extension String {
    static var DEV: String { AppConfiguration.DEV.rawValue }
    static var TEST_DEV: String { AppConfiguration.TEST_DEV.rawValue }
    static var TEST_PROD: String { AppConfiguration.TEST_PROD.rawValue }
    static var PROD: String { AppConfiguration.PROD.rawValue }
    static var SHARED: String { AppConfiguration.SHARED.rawValue }
}

public extension ConfigurationName {
    static var DEV: ConfigurationName { AppConfiguration.DEV.configurationName }
    static var TEST_DEV: ConfigurationName { AppConfiguration.TEST_DEV.configurationName }
    static var TEST_PROD: ConfigurationName { AppConfiguration.TEST_PROD.configurationName }
    static var PROD: ConfigurationName { AppConfiguration.PROD.configurationName }
    static var SHARED: ConfigurationName { AppConfiguration.SHARED.configurationName }
}
