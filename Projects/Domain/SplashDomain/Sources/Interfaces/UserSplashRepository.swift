//
//  UserSplashRepository.swift
//  SplashDomain
//
//  Created by JunHyeok Lee on 4/15/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RxSwift

import BaseDomain

public protocol UserSplashRepository {
    func signin(accessToken: String) -> Single<User>
    func fetchUserStorage() -> Single<User>
    func updateStorage(_ user: User) -> Single<User>
    func deleteUserStorage(userID: Int) -> Single<Void>
}
