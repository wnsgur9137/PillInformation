//
//  UserUseCase.swift
//  OnboardingPresentation
//
//  Created by JunHyeok Lee on 4/2/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RxSwift

public protocol UserUseCase {
    func executeUser(userID: Int) -> Single<UserModel>
    func save(_ user: UserModel) -> Single<Void>
}
