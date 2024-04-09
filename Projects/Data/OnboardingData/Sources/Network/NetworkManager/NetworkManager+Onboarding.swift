//
//  NetworkManager+Onboarding.swift
//  OnboardingData
//
//  Created by JunHyeok Lee on 4/9/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RxSwift
import Moya

import NetworkInfra
import OnboardingDomain

extension NetworkManager {
    public func postUser(token: String) -> Single<UserDTO> {
        return requestObject(.signin(token: token), type: UserDTO.self)
    }
}
