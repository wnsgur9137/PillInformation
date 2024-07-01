//
//  UserMyPageRepository.swift
//  MyPageDomain
//
//  Created by JunHyeok Lee on 6/27/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RxSwift

import BaseDomain

public protocol UserMyPageRepository {
    func getUser(userID: Int) -> Single<User>
    func postUser(_ user: User) -> Single<User>
    func deleteUser(userID: Int) -> Single<Void>
    
    func fetchStorage(userID: Int) -> Single<User>
    func fetchFirstUserStorage() -> Single<User>
    func updateStorage(_ user: User) -> Single<User>
    func deleteStorage(userID: Int) -> Single<Void>
}
