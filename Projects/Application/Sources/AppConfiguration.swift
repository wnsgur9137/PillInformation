//
//  AppConfiguration.swift
//  Application
//
//  Created by JunHyeok Lee on 2/13/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation

final class AppConfiguration {
    private let appConfigurations: [String: String] = {
        guard let appConfigurations = Bundle.main.infoDictionary?["AppConfigurations"] as? [String: String] else {
            fatalError("AppConfigurations must not be empty in plist")
        }
        return appConfigurations
    }()
    
    lazy var apiBaseURL: String = {
        var key: String = ""
        
        #if DEBUG
        key = "DEV_API_BASE_URL"
        #elseif RELEASE
        key = "API_BASE_URL"
        #endif
        
        guard let apiBaseURL = appConfigurations[key] else {
            fatalError("\(key) must not be empty in plist")
        }
        return apiBaseURL
    }()
    
    lazy var medicineApiURL: String = {
        guard let medicineApiURL = appConfigurations["MEDICINE_API_URL"] else {
            fatalError("MEDICINE_API_URL must not be empty in plist")
        }
        return medicineApiURL
    }()
    
    lazy var medicineApiKey: String = {
        guard let medicineApiKey = appConfigurations["MEDICINE_API_KEY"] else {
            fatalError("MEDICINE_API_KEY must not be empty in plist")
        }
        return medicineApiKey
    }()
    
    lazy var medicineInfoApiURL: String = {
        guard let medicineInfoApiURL = appConfigurations["MEDICINE_INFO_API_URL"] else {
            fatalError("MEDICINE_INFO_API_URL must not be empty in plist")
        }
        return medicineInfoApiURL
    }()
    
    lazy var medicineInfoApiKey: String = {
        guard let medicineInfoApiKey = appConfigurations["MEDICINE_INFO_API_KEY"] else {
            fatalError("MEDICINE_INFO_API_KEY must not be empty in plist")
        }
        return medicineInfoApiKey
    }()
    
    lazy var kakaoNativeAppKey: String = {
        guard let kakaoNativeAppKey = appConfigurations["KAKAO_NATIVE_APP_KEY"] else {
            fatalError("KAKAO_NATIVE_APP_KEY must not be empty in plist")
        }
        return kakaoNativeAppKey
    }()
}
