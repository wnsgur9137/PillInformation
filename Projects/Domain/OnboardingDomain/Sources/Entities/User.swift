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
    
    public init(id: Int, isAgreeAppPolicy: Bool, isAgreeAgePolicy: Bool, isAgreePrivacyPolicy: Bool, isAgreeDaytimeNoti: Bool, isAgreeNighttimeNoti: Bool) {
        self.id = id
        self.isAgreeAppPolicy = isAgreeAppPolicy
        self.isAgreeAgePolicy = isAgreeAgePolicy
        self.isAgreePrivacyPolicy = isAgreePrivacyPolicy
        self.isAgreeDaytimeNoti = isAgreeDaytimeNoti
        self.isAgreeNighttimeNoti = isAgreeNighttimeNoti
    }
}

extension User {
    func toModel() -> UserModel {
        return .init(id: self.id, isAgreeAppPolicy: self.isAgreeAppPolicy, isAgreeAgePolicy: self.isAgreeAgePolicy, isAgreePrivacyPolicy: self.isAgreePrivacyPolicy, isAgreeDaytimeNoti: self.isAgreeDaytimeNoti, isAgreeNighttimeNoti: self.isAgreeNighttimeNoti)
    }
}
