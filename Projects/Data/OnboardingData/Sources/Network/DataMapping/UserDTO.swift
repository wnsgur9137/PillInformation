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
}

extension UserDTO {
    func toDomain() -> User {
        return .init(id: self.id, isAgreeAppPolicy: self.isAgreeAppPolicy, isAgreeAgePolicy: self.isAgreeAgePolicy, isAgreePrivacyPolicy: self.isAgreePrivacyPolicy, isAgreeDaytimeNoti: self.isAgreeDaytimeNoti, isAgreeNighttimeNoti: self.isAgreeNighttimeNoti)
    }
}
