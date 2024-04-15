//
//  UserDTO.swift
//  OnboardingData
//
//  Created by JunHyeok Lee on 4/2/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation

public struct UserDTO: Decodable {
    public let id: Int
    public let isAgreeAppPolicy: Bool
    public let isAgreeAgePolicy: Bool
    public let isAgreePrivacyPolicy: Bool
    public let isAgreeDaytimeNoti: Bool
    public let isAgreeNighttimeNoti: Bool
    public let accessToken: String
    public let refreshToken: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case isAgreeAppPolicy = "is_agree_app_policy"
        case isAgreeAgePolicy = "is_agree_age_policy"
        case isAgreePrivacyPolicy = "is_agree_privacy_policy"
        case isAgreeDaytimeNoti = "is_agree_daytime_noti"
        case isAgreeNighttimeNoti = "is_agree_nighttime_noti"
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
    }
    
    public init(id: Int, isAgreeAppPolicy: Bool, isAgreeAgePolicy: Bool, isAgreePrivacyPolicy: Bool, isAgreeDaytimeNoti: Bool, isAgreeNighttimeNoti: Bool, accessToken: String, refreshToken: String) {
        self.id = id
        self.isAgreeAppPolicy = isAgreeAppPolicy
        self.isAgreeAgePolicy = isAgreeAgePolicy
        self.isAgreePrivacyPolicy = isAgreePrivacyPolicy
        self.isAgreeDaytimeNoti = isAgreeDaytimeNoti
        self.isAgreeNighttimeNoti = isAgreeNighttimeNoti
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
}
