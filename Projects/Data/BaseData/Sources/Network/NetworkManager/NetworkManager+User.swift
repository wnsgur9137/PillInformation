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
    
    public func signin(identifier: String, social: String) -> Single<UserDTO> {
        return requestObject(.signup(identifier: identifier, social: social), type: UserDTO.self)
    }
    
    public func signin(accessToken: String) -> Single<UserDTO> {
        return requestObject(.signin(accessToken: accessToken), type: UserDTO.self)
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
