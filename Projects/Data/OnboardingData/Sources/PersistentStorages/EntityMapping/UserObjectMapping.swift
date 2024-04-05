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
    
    convenience init(id: Int, isAgreeAppPolicy: Bool, isAgreeAgePolicy: Bool, isAgreePrivacyPolicy: Bool, isAgreeDaytimeNoti: Bool, isAgreeNighttimeNoti: Bool) {
        self.init()
        self.id = id
        self.isAgreeAppPolicy = isAgreeAppPolicy
        self.isAgreeAgePolicy = isAgreeAgePolicy
        self.isAgreePrivacyPolicy = isAgreePrivacyPolicy
        self.isAgreeDaytimeNoti = isAgreeDaytimeNoti
        self.isAgreeNighttimeNoti = isAgreeNighttimeNoti
    }
}

extension UserObject {
    func toDTO() -> UserDTO {
        return .init(id: self.id, isAgreeAppPolicy: self.isAgreeAppPolicy, isAgreeAgePolicy: self.isAgreeAgePolicy, isAgreePrivacyPolicy: self.isAgreePrivacyPolicy, isAgreeDaytimeNoti: self.isAgreeDaytimeNoti, isAgreeNighttimeNoti: self.isAgreeNighttimeNoti)
    }
}
