//
//  DefaultSplashUseCase.swift
//  SplashDomain
//
//  Created by JunHyeok Lee on 4/15/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RxSwift

import BaseDomain
import SplashPresentation

public final class DefaultSplashUseCase: SplashUseCase {
    
    private let applicationSplashRepository: ApplicationSplashRepository
    private let userSplashRepository: UserSplashRepository
    
    public init(applicationRepository: ApplicationSplashRepository,
                userRepository: UserSplashRepository) {
        self.applicationSplashRepository = applicationRepository
        self.userSplashRepository = userRepository
    }
}

extension DefaultSplashUseCase {
    public func deviceCheck(_ deviceToken: String) -> Single<DeviceCheckResultModel> {
        return applicationSplashRepository.deviceCheck(deviceToken).map { $0.toModel() }
    }
    
    public func executeIsNeedSignIn() -> Single<Bool> {
        return applicationSplashRepository.executeIsNeedSignIn()
    }
    
    public func signin(accessToken: String) -> Single<UserModel> {
        return userSplashRepository.signin(accessToken: accessToken).map { $0.toModel() }
    }
    
    public func fetchUserStorage() -> Single<UserModel> {
        return userSplashRepository.fetchUserStorage().map { $0.toModel() }
    }
    
    public func updateUserStorage(_ user: UserModel) -> Single<UserModel> {
        let user = User.makeUser(userModel: user)
        return userSplashRepository.updateStorage(user).map { $0.toModel() }
    }
    
    public func deleteUserStorage() -> Single<Void> {
        return userSplashRepository.deleteUserStorage()
    }
    
    public func updateIsShownOnboarding(_ isShown: Bool) -> Single<Bool> {
        return userSplashRepository.updateIsShownOnboarding(isShown)
    }
    
    public func isShownOnboarding() -> Single<Bool> {
        return userSplashRepository.isShownOnboarding()
    }
}
