//
//  DefaultUserRepository.swift
//  OnboardingData
//
//  Created by JunHyeok Lee on 4/2/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RxSwift

import NetworkInfra

public protocol UserRepository {
    func getUser(userID: Int) -> Single<UserDTO>
    func signinUser(identifier: String) -> Single<UserDTO>
    func signinUser(accessToken: String) -> Single<UserDTO>
    func postUser(_ user: UserDTO) -> Single<UserDTO>
    
    func fetchUserStorage(userID: Int) -> Single<UserDTO>
    func fetchFirstUser() -> Single<UserDTO>
    func saveStorage(_ user: UserDTO) -> Single<UserDTO>
    func updateStorage(_ user: UserDTO) -> Single<UserDTO>
    func deleteStorage(userID: Int) -> Single<Void>
    
    func saveEmailToKeychain(_ email: String) -> Single<Void>
    func getEmailToKeychain() -> Single<String>
    func updateEmailToKeychain(_ email: String) -> Single<String>
    func deleteEmailFromKeychain() -> Single<Void>
}

public struct DefaultUserRepository: UserRepository {
    
    private let networkManager: NetworkManager
    private let userStorage: UserStorage
    private let disposeBag = DisposeBag()
    
    public init(networkManager: NetworkManager,
                userStorage: UserStorage = DefaultUserStorage()) {
        self.networkManager = networkManager
        self.userStorage = userStorage
    }
}

extension DefaultUserRepository {
    public func getUser(userID: Int) -> Single<UserDTO> {
        return .create() { single in
            self.userStorage.getTokens(userID: userID)
                .flatMap { accessToken, refreshToken in
                    self.networkManager.getUser(token: accessToken)
                }
                .subscribe(onSuccess: { userDTO in
                    single(.success(userDTO))
                }, onFailure: { error in
                    single(.failure(error))
                })
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
    
    public func signinUser(identifier: String) -> Single<UserDTO> {
        let userDTO = networkManager.signin(identifier: identifier)
        
        return .create() { single in
            userDTO
                .flatMap { userDTO in
                    self.userStorage.save(response: userDTO)
                }
                .subscribe(onSuccess: { userDTO in
                    single(.success(userDTO))
                }, onFailure: { error in
                    single(.failure(error))
                })
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
    
    public func signinUser(accessToken: String) -> Single<UserDTO> {
        let userDTO = networkManager.signin(accessToken: accessToken)
        
        return .create() { single in
            userDTO
                .flatMap { userDTO in
                    self.userStorage.save(response: userDTO)
                }
                .subscribe(onSuccess: { userDTO in
                    single(.success(userDTO))
                }, onFailure: { error in
                    single(.failure(error))
                })
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
    
    public func postUser(_ user: UserDTO) -> Single<UserDTO> {
        return .create() { single in
            userStorage.getTokens(userID: user.id)
                .flatMap { accessToken, refreshToken -> Single<UserDTO> in
                    return networkManager.update(userDTO: user, token: accessToken)
                }
                .subscribe(onSuccess: { userDTO in
                    single(.success(userDTO))
                }, onFailure: { error in
                    single(.failure(error))
                })
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
    
    public func fetchUserStorage(userID: Int) -> Single<UserDTO> {
        return userStorage.get(userID: userID)
    }
    
    public func fetchFirstUser() -> Single<UserDTO> {
        return userStorage.getFirstUser()
    }
    
    public func saveStorage(_ user: UserDTO) -> Single<UserDTO> {
        return userStorage.save(response: user)
    }
    
    public func updateStorage(_ user: UserDTO) -> Single<UserDTO> {
        return userStorage.update(updatedResponse: user)
    }
    
    public func deleteStorage(userID: Int) -> Single<Void> {
        return userStorage.delete(userID: userID)
    }
    
    public func saveEmailToKeychain(_ email: String) -> Single<Void> {
        return userStorage.saveToKeychain(email)
    }
    
    public func getEmailToKeychain() -> Single<String> {
        return userStorage.getEmailFromKeychain()
    }
    
    public func updateEmailToKeychain(_ email: String) -> Single<String> {
        return userStorage.updateEmailToKeychain(email)
    }
    
    public func deleteEmailFromKeychain() -> Single<Void> {
        return userStorage.deleteEmailFromKeychain()
    }
}
