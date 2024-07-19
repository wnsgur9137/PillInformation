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
    func deleteUserStorage() -> Single<Void>
    func updateIsShownOnboarding(_ isShown: Bool) -> Single<Bool>
    func isShownOnboarding() -> Single<Bool>
}
