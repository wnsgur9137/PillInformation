//
//  DefaultUserUseCase.swift
//  OnboardingDomain
//
//  Created by JunHyeok Lee on 4/2/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RxSwift

import BaseDomain
import BasePresentation
import OnboardingPresentation

public final class DefaultUserUseCase: UserUseCase {
    
    private let userRepository: UserOnboardingRepository
    
    public init(with userRepository: UserOnboardingRepository) {
        self.userRepository = userRepository
    }
}

extension DefaultUserUseCase {
    public func executeUser(userID: Int) -> Single<UserModel> {
        return userRepository.getUser(userID: userID).map { $0.toModel() }
    }
    
    public func signin(identifier: String, social: String) -> Single<UserModel> {
        return userRepository.signinUser(identifier: identifier, social: social).map { $0.toModel() }
    }
    
    public func post(_ user: UserModel) -> Single<UserModel> {
        let user = User.makeUser(userModel: user)
        return userRepository.postUser(user).map { $0.toModel() }
    }
    
    public func fetchUserStorage(userID: Int) -> Single<UserModel> {
        return userRepository.fetchUserStorage(userID: userID).map { $0.toModel() }
    }
    
    public func saveStorage(_ userModel: UserModel) -> Single<UserModel> {
        let user = User.makeUser(userModel: userModel)
        return userRepository.saveStorage(user).map { $0.toModel() }
    }
    
    public func updateStorage(_ user: UserModel) -> Single<UserModel> {
        let user = User.makeUser(userModel: user)
        return userRepository.updateStorage(user).map { $0.toModel() }
    }
    
    public func saveEmailToKeychain(_ email: String) -> Single<Void> {
        return userRepository.saveEmailToKeychain(email)
    }
    
    public func getEmailToKeychain() -> Single<String> {
        return userRepository.getEmailToKeychain()
    }
    
    public func updateEmailToKeychain(_ email: String) -> Single<String> {
        return userRepository.updateEmailToKeychain(email)
    }
    
    public func deleteEmailFromKeychain() -> Single<Void> {
        return userRepository.deleteEmailFromKeychain()
    }
    
    public func updateIsShownOnboarding(_ isShown: Bool) -> Single<Bool> {
        return userRepository.setIsShownOnboarding(isShown)
    }
}
