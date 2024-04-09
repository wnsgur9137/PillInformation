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
import NetworkInfra

public struct DefaultUserRepository: UserRepository {
    
    private let networkManager: NetworkManager
    private let userStorage: UserStorage
    
    public init(networkManager: NetworkManager,
                userStorage: UserStorage = RealmUserStorage()) {
        self.networkManager = networkManager
        self.userStorage = userStorage
    }
}

extension DefaultUserRepository {
    public func fetchUser(userID: Int) -> Single<User> {
        return userStorage.get(userID: userID).map { $0.toDomain() }
    }
    
    public func postUser(token: String) -> Single<User> {
        return networkManager.postUser(token: token).map { $0.toDomain() }
    }
    
    public func save(_ user: User) -> Single<Void> {
        let userDTO = UserDTO(id: user.id, isAgreeAppPolicy: user.isAgreeAppPolicy, isAgreeAgePolicy: user.isAgreeAgePolicy, isAgreePrivacyPolicy: user.isAgreePrivacyPolicy, isAgreeDaytimeNoti: user.isAgreeDaytimeNoti, isAgreeNighttimeNoti: user.isAgreeNighttimeNoti, accessToken: user.accessToken, refreshToken: user.refreshToken)
        return userStorage.save(response: userDTO)
    }
}
