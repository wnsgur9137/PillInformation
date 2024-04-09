//
//  UserDTO.swift
//  OnboardingData
//
//  Created by JunHyeok Lee on 4/2/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation

import OnboardingDomain

public struct UserDTO: Decodable {
    let id: Int
    let isAgreeAppPolicy: Bool
    let isAgreeAgePolicy: Bool
    let isAgreePrivacyPolicy: Bool
    let isAgreeDaytimeNoti: Bool
    let isAgreeNighttimeNoti: Bool
    let accessToken: String
    let refreshToken: String
    
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
}

extension UserDTO {
    func toDomain() -> User {
        return .init(id: self.id, isAgreeAppPolicy: self.isAgreeAppPolicy, isAgreeAgePolicy: self.isAgreeAgePolicy, isAgreePrivacyPolicy: self.isAgreePrivacyPolicy, isAgreeDaytimeNoti: self.isAgreeDaytimeNoti, isAgreeNighttimeNoti: self.isAgreeNighttimeNoti, accessToken: self.accessToken, refreshToken: self.refreshToken)
    }
}
