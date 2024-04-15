//
//  UserObjectMapping.swift
//  OnboardingData
//
//  Created by JunHyeok Lee on 4/2/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RealmSwift

class UserObject: Object {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var isAgreeAppPolicy: Bool
    @Persisted var isAgreeAgePolicy: Bool
    @Persisted var isAgreePrivacyPolicy: Bool
    @Persisted var isAgreeDaytimeNoti: Bool
    @Persisted var isAgreeNighttimeNoti: Bool
    @Persisted var accessToken: String
    @Persisted var refreshToken: String
    
    convenience init(id: Int, isAgreeAppPolicy: Bool, isAgreeAgePolicy: Bool, isAgreePrivacyPolicy: Bool, isAgreeDaytimeNoti: Bool, isAgreeNighttimeNoti: Bool, accessToken: String, refreshToken: String) {
        self.init()
        self.id = id
        self.isAgreeAppPolicy = isAgreeAppPolicy
        self.isAgreeAgePolicy = isAgreeAgePolicy
        self.isAgreePrivacyPolicy = isAgreePrivacyPolicy
        self.isAgreeDaytimeNoti = isAgreeDaytimeNoti
        self.isAgreeNighttimeNoti = isAgreeNighttimeNoti
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
    
    
    convenience init(userDTO: UserDTO) {
        self.init()
        self.id = userDTO.id
        self.isAgreeAppPolicy = userDTO.isAgreeAppPolicy
        self.isAgreeAgePolicy = userDTO.isAgreeAgePolicy
        self.isAgreePrivacyPolicy = userDTO.isAgreePrivacyPolicy
        self.isAgreeDaytimeNoti = userDTO.isAgreeDaytimeNoti
        self.isAgreeNighttimeNoti = userDTO.isAgreeNighttimeNoti
        self.accessToken = userDTO.accessToken
        self.refreshToken = userDTO.refreshToken
    }
}

extension UserObject {
    func toDTO() -> UserDTO {
        return .init(id: self.id, isAgreeAppPolicy: self.isAgreeAppPolicy, isAgreeAgePolicy: self.isAgreeAgePolicy, isAgreePrivacyPolicy: self.isAgreePrivacyPolicy, isAgreeDaytimeNoti: self.isAgreeDaytimeNoti, isAgreeNighttimeNoti: self.isAgreeNighttimeNoti, accessToken: self.accessToken, refreshToken: self.refreshToken)
    }
}
