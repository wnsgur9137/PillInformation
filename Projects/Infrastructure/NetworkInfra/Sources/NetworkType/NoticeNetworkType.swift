//
//  NoticeNetworkType.swift
//  NetworkInfra
//
//  Created by JunHyeok Lee on 2/16/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RxSwift
import Moya

struct NoticeNetworkType: NetworkType {
    typealias T = NoticeTargetType
    let provider: NetworkProvider<T>
    
    static func defaultNetworking(baseURL: String) -> NoticeNetworkType {
        return NoticeNetworkType(provider: NetworkProvider(endpointClosure: NoticeNetworkType.endpointsClosure(baseURL: baseURL),
                                                           requestClosure: NoticeNetworkType.endpointResolver(),
                                                           stubClosure: NoticeNetworkType.APIKeysBasedStubBehaviour,
                                                           plugins: plugins))
    }
    
    static func stubbingNetworking(baseURL: String, needFail: Bool) -> NoticeNetworkType {
        if needFail {
            return NoticeNetworkType(provider: NetworkProvider(endpointClosure: failEndPointsClosure(baseURL: baseURL),
                                                               requestClosure: NoticeNetworkType.endpointResolver(),
                                                               stubClosure: MoyaProvider.immediatelyStub))
        }
        return NoticeNetworkType(provider: NetworkProvider(endpointClosure: endpointsClosure(baseURL: baseURL),
                                                           requestClosure: NoticeNetworkType.endpointResolver(),
                                                           stubClosure: MoyaProvider.immediatelyStub))
    }
}
