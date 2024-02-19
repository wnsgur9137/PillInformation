//
//  UserNetworkType.swift
//  NetworkInfra
//
//  Created by JunHyeok Lee on 2/16/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RxSwift
import Moya

struct UserNetworkType: NetworkType {
    typealias T = UserTargetType
    let provider: NetworkProvider<T>
    
    static func defaultNetworking(baseURL: String) -> UserNetworkType {
        return UserNetworkType(provider: NetworkProvider(endpointClosure: UserNetworkType.endpointsClosure(baseURL: baseURL),
                                                         requestClosure: UserNetworkType.endpointResolver(),
                                                         stubClosure: UserNetworkType.APIKeysBasedStubBehaviour,
                                                         plugins: plugins))
    }
    
    static func stubbingNetworking(baseURL: String, needFail: Bool) -> UserNetworkType {
        if needFail {
            return UserNetworkType(provider: NetworkProvider(endpointClosure: failEndPointsClosure(baseURL: baseURL),
                                                             requestClosure: UserNetworkType.endpointResolver(),
                                                             stubClosure: MoyaProvider.immediatelyStub))
        }
        return UserNetworkType(provider: NetworkProvider(endpointClosure: endpointsClosure(baseURL: baseURL),
                                                         requestClosure: UserNetworkType.endpointResolver(),
                                                         stubClosure: MoyaProvider.immediatelyStub))
    }
}
