//
//  DefaultUserUseCase.swift
//  SplashDomain
//
//  Created by JunHyeok Lee on 4/15/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RxSwift

import BaseDomain
import SplashPresentation

public final class DefaultUserUseCase: UserUseCase {
    
    private let userRepository: UserSplashRepository
    
    public init(with userRepository: UserSplashRepository) {
        self.userRepository = userRepository
    }
}

extension DefaultUserUseCase {
    public func signin(accessToken: String) -> Single<UserModel> {
        return userRepository.signin(accessToken: accessToken).map { $0.toModel() }
    }
    
    public func fetchUserStorage() -> Single<UserModel> {
        return userRepository.fetchUserStorage().map { $0.toModel() }
    }
    
    public func updateUserStorage(_ user: UserModel) -> Single<UserModel> {
        let user = User.makeUser(userModel: user)
        return userRepository.updateStorage(user).map { $0.toModel() }
    }
    
    public func deleteUserStorage() -> Single<Void> {
        return userRepository.deleteUserStorage()
    }
    
    public func deviceCheck(_ deviceToken: String) -> Single<DeviceCheckResultModel> {
        return userRepository.deviceCheck(deviceToken).map { $0.toModel() }
    }
}
