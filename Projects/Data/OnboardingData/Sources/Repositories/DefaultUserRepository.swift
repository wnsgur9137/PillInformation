//
//  DefaultUserRepository.swift
//  OnboardingData
//
//  Created by JunHyeok Lee on 4/2/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RxSwift

import OnboardingDomain

public struct DefaultUserRepository: UserRepository {
    
    private let userStorage: UserStorage
    
    public init(userStorage: UserStorage) {
        self.userStorage = userStorage
    }
}

extension DefaultUserRepository {
    public func fetchUser() -> Single<User> {
        return userStorage.getUserResponse().map { $0.toDomain() }
    }
    
    public func save(_ user: User) -> Single<Void> {
        let userDTO = UserDTO(id: user.id, isAgreeAppPolicy: user.isAgreeAppPolicy, isAgreeAgePolicy: user.isAgreeAgePolicy, isAgreePrivacyPolicy: user.isAgreePrivacyPolicy, isAgreeDaytimeNoti: user.isAgreeDaytimeNoti, isAgreeNighttimeNoti: user.isAgreeNighttimeNoti)
        return userStorage.save(response: userDTO)
    }
}
