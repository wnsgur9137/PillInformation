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
    
    public init(user: User) {
        self.id = user.id
        self.isAgreeAppPolicy = user.isAgreeAppPolicy
        self.isAgreeAgePolicy = user.isAgreeAgePolicy
        self.isAgreePrivacyPolicy = user.isAgreePrivacyPolicy
        self.isAgreeDaytimeNoti = user.isAgreeDaytimeNoti
        self.isAgreeNighttimeNoti = user.isAgreeNighttimeNoti
        self.accessToken = user.accessToken
        self.refreshToken = user.refreshToken
    }
}

extension UserDTO {
    func toDomain() -> User {
        return .init(id: self.id, isAgreeAppPolicy: self.isAgreeAppPolicy, isAgreeAgePolicy: self.isAgreeAgePolicy, isAgreePrivacyPolicy: self.isAgreePrivacyPolicy, isAgreeDaytimeNoti: self.isAgreeDaytimeNoti, isAgreeNighttimeNoti: self.isAgreeNighttimeNoti, accessToken: self.accessToken, refreshToken: self.refreshToken)
    }
}
