//
//  UserRepository.swift
//  OnboardingDomain
//
//  Created by JunHyeok Lee on 4/2/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RxSwift

public protocol UserRepository {
    func fetchUser(userID: Int) -> Single<User>
    func save(_ user: User) -> Single<Void>
}
