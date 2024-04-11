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
    private let disposeBag = DisposeBag()
    
    public init(networkManager: NetworkManager,
                userStorage: UserStorage = RealmUserStorage()) {
        self.networkManager = networkManager
        self.userStorage = userStorage
    }
}

extension DefaultUserRepository {
    public func getUser(userID: Int) -> Single<User> {
        return .create() { single in
            self.userStorage.getTokens(userID: userID)
                .flatMap { accessToken, refreshToken in
                    self.networkManager.getUser(token: accessToken)
                }
                .subscribe(onSuccess: { userDTO in
                    single(.success(userDTO.toDomain()))
                }, onFailure: { error in
                    single(.failure(error))
                })
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
    
    public func signinUser(token: String) -> Single<User> {
        let userDTO = networkManager.signin(token: token)
        
        return .create() { single in
            userDTO
                .flatMap { userDTO in
                    self.userStorage.save(response: userDTO)
                }
                .subscribe(onSuccess: { userDTO in
                    single(.success(userDTO.toDomain()))
                }, onFailure: { error in
                    single(.failure(error))
                })
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
    
    public func postUser(_ user: User) -> Single<User> {
        let userDTO = UserDTO(user: user)
        
        return .create() { single in
            userStorage.getTokens(userID: user.id)
                .flatMap { accessToken, refreshToken -> Single<UserDTO> in
                    return networkManager.update(userDTO: userDTO, token: accessToken)
                }
                .subscribe(onSuccess: { userDTO in
                    single(.success(userDTO.toDomain()))
                }, onFailure: { error in
                    single(.failure(error))
                })
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
    
    public func fetchUserStorage(userID: Int) -> Single<User> {
        return userStorage.get(userID: userID).map { $0.toDomain() }
    }
    
    public func saveStorage(_ user: User) -> Single<User> {
        let userDTO = UserDTO(user: user)
        return userStorage.save(response: userDTO).map { $0.toDomain() }
    }
    
    public func updateStorage(_ user: User) -> Single<User> {
        let userDTO = UserDTO(user: user)
        return userStorage.update(updatedResponse: userDTO).map { $0.toDomain() }
    }
}
