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
    private let disposeBag = DisposeBag()
    
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
    
    public func fetchUserStorage(userID: Int) -> Single<UserModel> {
        return userRepository.fetchStorage(userID: userID).map { $0.toModel() }
    }
    
    public func fetchFirstUserStorage() -> Single<UserModel> {
        return userRepository.fetchFirstUserStorage().map { $0.toModel() }
    }
    
    public func signOut() -> Single<Void> {
        return .create() { single in
            self.fetchFirstUserStorage()
                .flatMap { user in
                    return self.userRepository.deleteStorage(userID: user.id)
                }
                .subscribe(onSuccess: { _ in
                    single(.success(Void()))
                }, onFailure: { error in
                    single(.failure(error))
                })
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
    
    public func withdrawal() -> Single<Void> {
        return .create() { single in
            self.fetchFirstUserStorage()
                .subscribe(onSuccess: { user in
                    Single.zip(
                        self.userRepository.deleteUser(userID: user.id),
                        self.userRepository.deleteStorage(userID: user.id)
                    ).subscribe(onSuccess: { _ in
                        single(.success(Void()))
                    }, onFailure: { error in
                        single(.failure(error))
                    })
                    .disposed(by: self.disposeBag)
                })
        }
    }
}
