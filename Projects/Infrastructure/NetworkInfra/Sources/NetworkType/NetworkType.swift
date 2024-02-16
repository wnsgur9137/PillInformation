//
//  NetworkType.swift
//  NetworkInfra
//
//  Created by JunHyeok Lee on 2/16/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import Moya
import RxSwift
import Common

protocol NetworkType {
    associatedtype T: MoyaErrorHandleable
    var provider: NetworkProvider<T> { get }
    
    static func defaultNetworking() -> Self
    static func stubbingNetworking(needFail: Bool) -> Self
}

extension NetworkType {
    static func endpointsClosure<T>() -> (T) -> Endpoint where T: TargetType {
        return { target in
            let endpoint = MoyaProvider.defaultEndpointMapping(for: target)
            return endpoint
        }
    }
    
    static func failEndPointsClosure<T>() -> (T) -> Endpoint where T: TargetType {
        return { target in
            let sampleResponseClosure: () -> EndpointSampleResponse = {
                EndpointSampleResponse.networkResponse(999, target.sampleData)
            }
            return .init(url: URL(target: target).absoluteString,
                         sampleResponseClosure: sampleResponseClosure,
                         method: target.method,
                         task: target.task,
                         httpHeaderFields: target.headers)
        }
    }
    
    static func APIKeysBasedStubBehaviour<T>(_: T) -> Moya.StubBehavior {
        return .never
    }
    
    static var plugins: [PluginType] {
        return getneratePlugIn()
    }
    
    static func endpointResolver() -> MoyaProvider<T>.RequestClosure {
        return { (endpoint, closure) in
            do {
                var request = try endpoint.urlRequest() // endpoint.urlRequest
                request.httpShouldHandleCookies = false
                closure(.success(request))
            } catch {
                Log(error.localizedDescription)
            }
        }
    }
    
    // TODO: - Slack 등의 API를 이용한 로그 출력 구현 예정
    private static func getneratePlugIn() -> [PluginType] {
        return []
    }
}
