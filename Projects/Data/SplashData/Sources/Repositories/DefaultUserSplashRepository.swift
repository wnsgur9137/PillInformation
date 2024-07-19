//
//  DefaultUserSplashRepository.swift
//  SplashData
//
//  Created by JunHyeok Lee on 4/15/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RxSwift

import NetworkInfra
import BaseData
import BaseDomain
import SplashDomain

public struct DefaultUserSplashRepository: UserSplashRepository {
    
    private let network: NetworkManager
    private let userRepository: UserRepository
    private let splashUserDefaultStoarge: SplashUserDefaultStorage
    
    public init(networkManager: NetworkManager,
                userRepository: UserRepository,
                splashUserDefaultStorage: SplashUserDefaultStorage = SplashUserDefaultStorage()) {
        self.network = networkManager
        self.userRepository = userRepository
        self.splashUserDefaultStoarge = splashUserDefaultStorage
    }
}

extension DefaultUserSplashRepository {
    public func signin(accessToken: String) -> Single<User> {
        return userRepository.signinUser(accessToken: accessToken).map { $0.toDomain() }
    }
    
    public func fetchUserStorage() -> Single<User> {
        return userRepository.fetchFirstUser().map { $0.toDomain() }
    }
    
    public func updateStorage(_ user: User) -> Single<User> {
        let userDTO = UserDTO.makeDTO(user: user)
        return userRepository.updateStorage(userDTO).map { $0.toDomain() }
    }
    
    public func deleteUserStorage() -> Single<Void> {
        return userRepository.deleteStorage()
    }
    
    public func updateIsShownOnboarding(_ isShown: Bool) -> Single<Bool> {
        return splashUserDefaultStoarge.setIsShownOnboarding(isShown)
    }
    
    public func isShownOnboarding() -> Single<Bool> {
        return splashUserDefaultStoarge.isShownOnbarding()
    }
}
