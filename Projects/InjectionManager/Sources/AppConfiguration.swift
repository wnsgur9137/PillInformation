//
//  AppConfiguration.swift
//  InjectionManager
//
//  Created by JunHyoek Lee on 8/21/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation

public final class AppConfiguration {
    private let appConfigurations: [String: String] = {
        guard let appConfigurations = Bundle.main.infoDictionary?["AppConfigurations"] as? [String: String] else {
            fatalError("AppConfigurations must not be empty in plist")
        }
        return appConfigurations
    }()
    
    public lazy var apiBaseURL: String = {
        guard let apiBaseURL = appConfigurations["API_BASE_URL"] else {
            fatalError("API_BASE_URL must not be empty in plist")
        }
        return apiBaseURL
    }()
    
    public lazy var medicineApiURL: String = {
        guard let medicineApiURL = appConfigurations["MEDICINE_API_URL"] else {
            fatalError("MEDICINE_API_URL must not be empty in plist")
        }
        return medicineApiURL
    }()
    
    public lazy var medicineApiKey: String = {
        guard let medicineApiKey = appConfigurations["MEDICINE_API_KEY"] else {
            fatalError("MEDICINE_API_KEY must not be empty in plist")
        }
        return medicineApiKey
    }()
    
    public lazy var medicineInfoApiURL: String = {
        guard let medicineInfoApiURL = appConfigurations["MEDICINE_INFO_API_URL"] else {
            fatalError("MEDICINE_INFO_API_URL must not be empty in plist")
        }
        return medicineInfoApiURL
    }()
    
    public lazy var medicineInfoApiKey: String = {
        guard let medicineInfoApiKey = appConfigurations["MEDICINE_INFO_API_KEY"] else {
            fatalError("MEDICINE_INFO_API_KEY must not be empty in plist")
        }
        return medicineInfoApiKey
    }()
    
    public lazy var kakaoNativeAppKey: String = {
        guard let kakaoNativeAppKey = appConfigurations["KAKAO_NATIVE_APP_KEY"] else {
            fatalError("KAKAO_NATIVE_APP_KEY must not be empty in plist")
        }
        return kakaoNativeAppKey
    }()
    
    public lazy var isShowAlarmTab: Bool = {
        guard let isShowAlarmTabString = appConfigurations["IS_SHOW_ALARM_TAB"] else {
            fatalError("IS_SHOW_ALARM_TAB must not be empty in plist")
        }
        return false
    }()
    
    public lazy var isShowAlarmPrivacy: Bool = {
        guard let isShowAlarmPrivacyString = appConfigurations["IS_SHOW_ALARM_PRIVACY"] else {
            fatalError("IS_SHOW_ALARM_PRIVACY must not be empty in plist")
        }
        return Bool(isShowAlarmPrivacyString) ?? false
    }()
}

