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

protocol NetworkType {
    associatedtype T: MoyaErrorHandleable
    var provider: NetworkProvider<T> { get }
    
    static func defaultNetworking(baseURL: String) -> Self
    static func stubbingNetworking(baseURL: String, needFail: Bool) -> Self
}

extension NetworkType {
    static func endpointsClosure<T>(baseURL: String) -> (T) -> Endpoint where T: TargetType {
        return { target in
            let url = baseURL + target.path
            return Endpoint(
                url: url,
                sampleResponseClosure: {
                    .networkResponse(200, target.sampleData )
                },
                method: target.method,
                task: target.task,
                httpHeaderFields: target.headers
            )
        }
    }
    
    static func failEndPointsClosure<T>(baseURL: String) -> (T) -> Endpoint where T: TargetType {
        return { target in
            let url = baseURL + target.path
            let sampleResponseClosure: () -> EndpointSampleResponse = {
                EndpointSampleResponse.networkResponse(999, target.sampleData)
            }
            return .init(
                url: url,
                sampleResponseClosure: sampleResponseClosure,
                method: target.method,
                task: target.task,
                httpHeaderFields: target.headers
            )
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
    
    func request(_ route: T) -> Single<Moya.Response> {
        let actualRequest = self.provider.request(route)
        return actualRequest
    }
}
