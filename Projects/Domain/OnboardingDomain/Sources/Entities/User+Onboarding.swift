//
//  User+Onboarding.swift
//  OnboardingDomain
//
//  Created by JunHyeok Lee on 6/27/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation

import BaseDomain
import BasePresentation

extension User {
    static func makeUser(userModel: UserModel) -> User {
        return User(id: userModel.id, isAgreeAppPolicy: userModel.isAgreeAppPolicy, isAgreeAgePolicy: userModel.isAgreeAgePolicy, isAgreePrivacyPolicy: userModel.isAgreePrivacyPolicy, isAgreeDaytimeNoti: userModel.isAgreeDaytimeNoti, isAgreeNighttimeNoti: userModel.isAgreeNighttimeNoti, accessToken: userModel.accessToken, refreshToken: userModel.refreshToken, social: userModel.social)
    }
    
    func toModel() -> UserModel {
        return .init(id: self.id, isAgreeAppPolicy: self.isAgreeAppPolicy, isAgreeAgePolicy: self.isAgreeAgePolicy, isAgreePrivacyPolicy: self.isAgreePrivacyPolicy, isAgreeDaytimeNoti: self.isAgreeDaytimeNoti, isAgreeNighttimeNoti: self.isAgreeNighttimeNoti, accessToken: self.accessToken, refreshToken: self.refreshToken, social: self.social)
    }
}
