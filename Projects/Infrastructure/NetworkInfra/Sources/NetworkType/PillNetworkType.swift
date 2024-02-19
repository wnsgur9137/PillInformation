//
//  PillNetworkType.swift
//  NetworkInfra
//
//  Created by JunHyeok Lee on 2/16/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RxSwift
import Moya

struct PillNetworkType: NetworkType {
    typealias T = PillTargetType
    let provider: NetworkProvider<T>
    
    static func defaultNetworking(baseURL: String) -> PillNetworkType {
        return PillNetworkType(provider: NetworkProvider(endpointClosure: PillNetworkType.endpointsClosure(baseURL: baseURL),
                                                         requestClosure: PillNetworkType.endpointResolver(),
                                                         stubClosure: PillNetworkType.APIKeysBasedStubBehaviour,
                                                         plugins: plugins))
    }
    
    static func stubbingNetworking(baseURL: String, needFail: Bool) -> PillNetworkType {
        if needFail {
            return PillNetworkType(provider: NetworkProvider(endpointClosure: failEndPointsClosure(baseURL: baseURL),
                                                             requestClosure: PillNetworkType.endpointResolver(),
                                                             stubClosure: MoyaProvider.immediatelyStub))
        }
        return PillNetworkType(provider: NetworkProvider(endpointClosure: endpointsClosure(baseURL: baseURL),
                                                         requestClosure: PillNetworkType.endpointResolver(),
                                                         stubClosure: MoyaProvider.immediatelyStub))
    }
}
