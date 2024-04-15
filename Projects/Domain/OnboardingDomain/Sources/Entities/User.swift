//
//  User.swift
//  OnboardingDomain
//
//  Created by JunHyeok Lee on 4/2/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation

import OnboardingPresentation

public struct User {
    public let id: Int
    public let isAgreeAppPolicy: Bool
    public let isAgreeAgePolicy: Bool
    public let isAgreePrivacyPolicy: Bool
    public let isAgreeDaytimeNoti: Bool
    public let isAgreeNighttimeNoti: Bool
    public let accessToken: String
    public let refreshToken: String
    
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
    
    public init(userModel: UserModel) {
        self.id = userModel.id
        self.isAgreeAppPolicy = userModel.isAgreeAppPolicy
        self.isAgreeAgePolicy = userModel.isAgreeAgePolicy
        self.isAgreePrivacyPolicy = userModel.isAgreePrivacyPolicy
        self.isAgreeDaytimeNoti = userModel.isAgreeDaytimeNoti
        self.isAgreeNighttimeNoti = userModel.isAgreeNighttimeNoti
        self.accessToken = userModel.accessToken
        self.refreshToken = userModel.refreshToken
    }
}

extension User {
    func toModel() -> UserModel {
        return .init(id: self.id, isAgreeAppPolicy: self.isAgreeAppPolicy, isAgreeAgePolicy: self.isAgreeAgePolicy, isAgreePrivacyPolicy: self.isAgreePrivacyPolicy, isAgreeDaytimeNoti: self.isAgreeDaytimeNoti, isAgreeNighttimeNoti: self.isAgreeNighttimeNoti, accessToken: self.accessToken, refreshToken: self.refreshToken)
    }
}
