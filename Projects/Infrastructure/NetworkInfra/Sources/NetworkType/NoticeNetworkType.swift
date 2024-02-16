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
    
    static func defaultNetworking() -> NoticeNetworkType {
        return NoticeNetworkType(provider: NetworkProvider(endpointClosure: NoticeNetworkType.endpointsClosure(),
                                                           requestClosure: NoticeNetworkType.endpointResolver(),
                                                           stubClosure: NoticeNetworkType.APIKeysBasedStubBehaviour,
                                                           plugins: plugins))
    }
    
    static func stubbingNetworking(needFail: Bool) -> NoticeNetworkType {
        if needFail {
            return NoticeNetworkType(provider: NetworkProvider(endpointClosure: failEndPointsClosure(),
                                                               requestClosure: NoticeNetworkType.endpointResolver(),
                                                               stubClosure: MoyaProvider.immediatelyStub))
        }
        return NoticeNetworkType(provider: NetworkProvider(endpointClosure: endpointsClosure(),
                                                           requestClosure: NoticeNetworkType.endpointResolver(),
                                                           stubClosure: MoyaProvider.immediatelyStub))
    }
}
