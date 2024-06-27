//
//  DefaultUserMyPageUseCase.swift
//  MyPageDomain
//
//  Created by JunHyeok Lee on 6/27/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RxSwift

import BaseDomain
import BasePresentation
import MyPagePresentation

public final class DefaultUserMyPageUseCase: UserUseCase {
    private let userRepository: UserMyPageRepository
    
    public init(with userRepository: UserMyPageRepository) {
        self.userRepository = userRepository
    }
    
    private func post(_ user: UserModel) -> Single<UserModel> {
        let user = User.makeUser(userModel: user)
        return userRepository.postUser(user).map { $0.toModel() }
    }
    
    private func updateStorage(_ userModel: UserModel) -> Single<UserModel> {
        let user = User.makeUser(userModel: userModel)
        return userRepository.updateStorage(user).map { $0.toModel() }
    }
}

extension DefaultUserMyPageUseCase {
    public func executeUser(userID: Int) -> Single<UserModel> {
        return userRepository.getUser(userID: userID).map { $0.toModel() }
    }
    
    public func update(_ userModel: UserModel) -> Single<UserModel> {
        return post(userModel)
            .flatMap { postedUser in
                return self.updateStorage(userModel)
            }
            .catch { error in
                return Single.error(error)
            }
    }
    
    public func delete(userID: Int) -> Single<Void> {
        return userRepository.deleteUser(userID: userID)
    }
    
    public func fetchUserStorage(userID: Int) -> Single<UserModel> {
        return userRepository.fetchStorage(userID: userID).map { $0.toModel() }
    }
    
    public func fetchFirstUserStorage() -> Single<UserModel> {
        return userRepository.fetchFirstUserStorage().map { $0.toModel() }
    }
    
    public func deleteStorage(userID: Int) -> Single<Void> {
        return userRepository.deleteStorage(userID: userID)
    }
}
