//
//  SplashUseCase.swift
//  SplashPresentation
//
//  Created by JunHyeok Lee on 4/15/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RxSwift

public protocol SplashUseCase {
    func deviceCheck(_ deviceToken: String) -> Single<DeviceCheckResultModel>
    func executeIsNeedSignIn() -> Single<Bool>
    func signin(accessToken: String) -> Single<UserModel>
    func fetchUserStorage() -> Single<UserModel>
    func updateUserStorage(_ user: UserModel) -> Single<UserModel>
    func deleteUserStorage() -> Single<Void>
    func updateIsShownOnboarding(_ isShown: Bool) -> Single<Bool>
    func isShownOnboarding() -> Single<Bool>
}
