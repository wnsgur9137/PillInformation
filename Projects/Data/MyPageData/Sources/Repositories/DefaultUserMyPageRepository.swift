//
//  DefaultUserMyPageRepository.swift
//  MyPageData
//
//  Created by JunHyeok Lee on 6/27/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RxSwift

import BaseData
import BaseDomain
import MyPageDomain

public struct DefaultUserMyPageRepository: UserMyPageRepository {
    private let userRepository: UserRepository
    
    public init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
}

extension DefaultUserMyPageRepository {
    public func getUser(userID: Int) -> Single<User> {
        return userRepository.getUser(userID: userID).map { $0.toDomain() }
    }
    
    public func postUser(_ user: User) -> Single<User> {
        let userDTO = UserDTO.makeDTO(user: user)
        return userRepository.postUser(userDTO).map { $0.toDomain() }
    }
    
    public func deleteUser(userID: Int) -> Single<Void> {
        return userRepository.deleteUser(userID)
    }
    
    public func fetchStorage(userID: Int) -> Single<User> {
        return userRepository.fetchUserStorage(userID: userID).map { $0.toDomain() }
    }
    
    public func fetchFirstUserStorage() -> Single<User> {
        return userRepository.fetchFirstUser().map { $0.toDomain() }
    }
    
    public func updateStorage(_ user: User) -> Single<User> {
        let userDTO = UserDTO.makeDTO(user: user)
        return userRepository.updateStorage(userDTO).map { $0.toDomain() }
    }
    
    public func deleteStorage(userID: Int) -> Single<Void> {
        return userRepository.deleteStorage(userID: userID)
    }
}
