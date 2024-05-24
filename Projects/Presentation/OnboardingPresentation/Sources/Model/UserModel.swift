//
//  UserModel.swift
//  OnboardingPresentation
//
//  Created by JunHyeok Lee on 4/2/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation

public struct UserModel {
    public let id: Int
    public let isAgreeAppPolicy: Bool
    public let isAgreeAgePolicy: Bool
    public let isAgreePrivacyPolicy: Bool
    public let isAgreeDaytimeNoti: Bool
    public let isAgreeNighttimeNoti: Bool
    public let accessToken: String
    public let refreshToken: String
    public let social: String
    
    public init(id: Int, isAgreeAppPolicy: Bool, isAgreeAgePolicy: Bool, isAgreePrivacyPolicy: Bool, isAgreeDaytimeNoti: Bool, isAgreeNighttimeNoti: Bool, accessToken: String, refreshToken: String, social: String) {
        self.id = id
        self.isAgreeAppPolicy = isAgreeAppPolicy
        self.isAgreeAgePolicy = isAgreeAgePolicy
        self.isAgreePrivacyPolicy = isAgreePrivacyPolicy
        self.isAgreeDaytimeNoti = isAgreeDaytimeNoti
        self.isAgreeNighttimeNoti = isAgreeNighttimeNoti
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.social = social
    }
    
    public var isAgreeRequredPolicies: Bool {
        return isAgreeAgePolicy && isAgreeAgePolicy && isAgreePrivacyPolicy
    }
}
