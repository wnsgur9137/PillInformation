//
//  AppConfiguration.swift
//  HomeDemoApp
//
//  Created by JunHyeok Lee on 8/28/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation

final class HomeDemoAppConfiguration {
    private let appConfigurations: [String: String] = {
        guard let appConfigurations = Bundle.main.infoDictionary?["AppConfigurations"] as? [String: String] else {
            fatalError("AppConfigurations is not found in plist")
        }
        return appConfigurations
    }()
    
    lazy var apiBaseURL: String = {
        guard let apiBaseURL = appConfigurations["API_BASE_URL"] else {
            fatalError("API_BASE_URL must not be empty in plist")
        }
        return apiBaseURL
    }()
}
