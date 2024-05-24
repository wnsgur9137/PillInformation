//
//  UserDTO+Splash.swift
//  SplashData
//
//  Created by JunHyeok Lee on 4/15/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation

import BaseData
import BaseDomain

extension UserDTO {
    static func makeDTO(user: User) -> UserDTO {
        return UserDTO(id: user.id, isAgreeAppPolicy: user.isAgreeAppPolicy, isAgreeAgePolicy: user.isAgreeAgePolicy, isAgreePrivacyPolicy: user.isAgreePrivacyPolicy, isAgreeDaytimeNoti: user.isAgreeDaytimeNoti, isAgreeNighttimeNoti: user.isAgreeNighttimeNoti, accessToken: user.accessToken, refreshToken: user.refreshToken, social: user.social)
    }
    
    func toDomain() -> User {
        return .init(id: self.id, isAgreeAppPolicy: self.isAgreeAppPolicy, isAgreeAgePolicy: self.isAgreeAgePolicy, isAgreePrivacyPolicy: self.isAgreePrivacyPolicy, isAgreeDaytimeNoti: self.isAgreeDaytimeNoti, isAgreeNighttimeNoti: self.isAgreeNighttimeNoti, accessToken: self.accessToken, refreshToken: self.refreshToken, social: self.social)
    }
}
