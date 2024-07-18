//
//  UserUseCase.swift
//  SplashPresentation
//
//  Created by JunHyeok Lee on 4/15/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RxSwift

public protocol UserUseCase {
    func signin(accessToken: String) -> Single<UserModel>
    func fetchUserStorage() -> Single<UserModel>
    func updateUserStorage(_ user: UserModel) -> Single<UserModel>
    func deleteUserStorage() -> Single<Void>
    func deviceCheck(_ deviceToken: String) -> Single<DeviceCheckResultModel>
}
