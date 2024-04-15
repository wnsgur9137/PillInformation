//
//  DefaultUserOnboardingRepository.swift
//  OnboardingData
//
//  Created by JunHyeok Lee on 4/2/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RxSwift

import BaseData
import BaseDomain
import OnboardingDomain

public struct DefaultUserOnboardingRepository: UserOnboardingRepository {
    
    private let userRepository: UserRepository
    
    public init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
}

extension DefaultUserOnboardingRepository {
    public func getUser(userID: Int) -> Single<User> {
        return userRepository.getUser(userID: userID).map { $0.toDomain() }
    }
    
    public func signinUser(identifier: String) -> Single<User> {
        return userRepository.signinUser(identifier: identifier).map { $0.toDomain() }
    }
    
    public func signinUser(accessToken: String) -> Single<User> {
        return userRepository.signinUser(accessToken: accessToken).map { $0.toDomain() }
    }
    
    public func postUser(_ user: User) -> Single<User> {
        let userDTO = UserDTO.makeDTO(user: user)
        return userRepository.postUser(userDTO).map { $0.toDomain() }
    }
    
    public func fetchUserStorage(userID: Int) -> Single<User> {
        return userRepository.fetchUserStorage(userID: userID).map { $0.toDomain() }
    }
    
    public func saveStorage(_ user: User) -> Single<User> {
        let userDTO = UserDTO.makeDTO(user: user)
        return userRepository.saveStorage(userDTO).map { $0.toDomain() }
    }
    
    public func updateStorage(_ user: User) -> Single<User> {
        let userDTO = UserDTO.makeDTO(user: user)
        return userRepository.updateStorage(userDTO).map { $0.toDomain() }
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
}
