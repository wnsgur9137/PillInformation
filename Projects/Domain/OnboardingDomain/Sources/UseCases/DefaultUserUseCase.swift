//
//  DefaultUserUseCase.swift
//  OnboardingDomain
//
//  Created by JunHyeok Lee on 4/2/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RxSwift

import OnboardingPresentation

public final class DefaultUserUseCase: UserUseCase {
    
    private let userRepository: UserRepository
    
    public init(with userRepository: UserRepository) {
        self.userRepository = userRepository
    }
}

extension DefaultUserUseCase {
    public func executeUser() -> Single<UserModel> {
        return userRepository.fetchUser().map { $0.toModel() }
    }
    
    public func save(_ userModel: UserModel) -> Single<Void> {
        let user = User(id: userModel.id, isAgreeAppPolicy: userModel.isAgreeAppPolicy, isAgreeAgePolicy: userModel.isAgreeAgePolicy, isAgreePrivacyPolicy: userModel.isAgreePrivacyPolicy, isAgreeDaytimeNoti: userModel.isAgreeDaytimeNoti, isAgreeNighttimeNoti: userModel.isAgreeNighttimeNoti)
        return userRepository.save(user)
    }
}
