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

extension NetworkManager {
    public func getUser(token: String) -> Single<UserDTO> {
        return requestObject(.getUser(token: token), type: UserDTO.self)
    }
    
    public func signin(identifier: String) -> Single<UserDTO> {
        return requestObject(.signin(identifier: identifier), type: UserDTO.self)
    }
    
    public func update(userDTO: UserDTO, token: String) -> Single<UserDTO> {
        return requestObject(.updateUser(appPolicy: userDTO.isAgreeAppPolicy,
                                         agePolicy: userDTO.isAgreeAgePolicy,
                                         privacyPolicy: userDTO.isAgreePrivacyPolicy,
                                         daytimeNoti: userDTO.isAgreeDaytimeNoti,
                                         nighttimeNoti: userDTO.isAgreeNighttimeNoti,
                                         token: token),
                             type: UserDTO.self)
    }
}
