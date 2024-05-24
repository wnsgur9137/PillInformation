//
//  NetworkProvider.swift
//  NetworkInfra
//
//  Created by JunHyeok Lee on 2/13/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import RxMoya

final class NetworkProvider<Target> where Target: MoyaErrorHandleable {
    fileprivate let provider: MoyaProvider<Target>
    
    init(endpointClosure: @escaping MoyaProvider<Target>.EndpointClosure = MoyaProvider<Target>.defaultEndpointMapping,
         requestClosure: @escaping MoyaProvider<Target>.RequestClosure = MoyaProvider<Target>.defaultRequestMapping,
         stubClosure: @escaping MoyaProvider<Target>.StubClosure = MoyaProvider<Target>.neverStub,
         session: Session = DefaultAlamofireManager.sharedManager,
         plugins: [PluginType] = [],
         trackInflights: Bool = false) {
        self.provider = MoyaProvider(endpointClosure: endpointClosure,
                                     requestClosure: requestClosure,
                                     stubClosure: stubClosure,
                                     session: session,
                                     plugins: plugins,
                                     trackInflights: trackInflights)
    }
}

extension NetworkProvider {
    func request(_ route: Target) -> Single<Moya.Response> {
        return provider.rx.request(route)
            .filterSuccessfulStatusCodes()
            .catch(route.internetConnection)
            .catch(route.timedOut)
            .catch(route.tokenError)
            .catch(route.rest)
            .do (
                onSuccess: { response in
//                    print("response: \(String(describing: String(data: response.data, encoding: .utf8)))")
                },
                onError: { rawError in
                    print("🚨ERROR-\(route.path)")
                    switch rawError {
                    case NetworkError.requestTimedOut:
                        print("NetworkError: TimedOut")
                    case NetworkError.internetConnection:
                        print("NetworkError: internetConnection")
                    case let NetworkError.rest(error, statusCode, errorCode, message):
                        print("NetworkError: rest(\(error)")
                        print("\tError: \(error.localizedDescription)")
                        print("\tStatusCode: \(statusCode ?? 0)")
                        print("\tErrorCode: \(errorCode ?? "null")")
                        print("\tMessage: \(message ?? "null")")
                    default:
                        break
                    }
                }
            )
            .retry(2)
    }
}
