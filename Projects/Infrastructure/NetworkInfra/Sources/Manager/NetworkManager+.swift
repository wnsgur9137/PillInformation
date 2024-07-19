//
//  NetworkManager+.swift
//  NetworkInfra
//
//  Created by JunHyeok Lee on 2/19/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Moya

// MARK: - Application
public extension NetworkManager {
    func request(_ target: ApplicationTargetType) -> Single<Any> {
        return applicationProvider.request(target).mapJSON()
    }
    
    func requestWithoutMapping(_ target: ApplicationTargetType) -> Single<Moya.Response> {
        return applicationProvider.request(target)
    }
    
    func requestObject<T: Decodable>(_ target: ApplicationTargetType, type: T.Type) -> Single<T> {
        return applicationProvider.request(target).map(T.self, using: JSONDecoder())
    }
    
    func requestArray<T: Decodable>(_ target: ApplicationTargetType, type: T.Type) -> Single<[T]> {
        return applicationProvider.request(target).map([T].self, using: JSONDecoder())
    }
}

// MARK: - User
public extension NetworkManager {
    func request(_ target: UserTargetType) -> Single<Any> {
        return userProvider.request(target).mapJSON()
    }
    
    func requestWithoutMapping(_ target: UserTargetType) -> Single<Moya.Response> {
        return userProvider.request(target)
    }
    
    func requestObject<T: Decodable>(_ target: UserTargetType, type: T.Type) -> Single<T> {
        return userProvider.request(target).map(T.self, using: JSONDecoder())
    }
    
    func requestArray<T: Decodable>(_ target: UserTargetType, type: T.Type) -> Single<[T]> {
        return userProvider.request(target).map([T].self, using: JSONDecoder())
    }
}

// MARK: - Pill
public extension NetworkManager {
    func request(_ target: PillTargetType) -> Single<Any> {
        return pillProvider.request(target).mapJSON()
    }
    
    func requestWithoutMapping(_ target: PillTargetType) -> Single<Moya.Response> {
        return pillProvider.request(target)
    }
    
    func requestObject<T: Decodable>(_ target: PillTargetType, type: T.Type) -> Single<T> {
        return pillProvider.request(target).map(T.self, using: JSONDecoder())
    }
    
    func requestArray<T: Decodable>(_ target: PillTargetType, type: T.Type) -> Single<[T]> {
        return pillProvider.request(target).map([T].self, using: JSONDecoder())
    }
}

// MARK: - Notice
public extension NetworkManager {
    func request(_ target: NoticeTargetType) -> Single<Any> {
        return noticeProvider.request(target).mapJSON()
    }
    
    func requestWithoutMapping(_ target: NoticeTargetType) -> Single<Moya.Response> {
        return noticeProvider.request(target)
    }
    
    func requestObject<T: Decodable>(_ target: NoticeTargetType, type: T.Type) -> Single<T> {
        return noticeProvider.request(target).map(T.self, using: JSONDecoder())
    }
    
    func requestArray<T: Decodable>(_ target: NoticeTargetType, type: T.Type) -> Single<[T]> {
        return noticeProvider.request(target).map([T].self, using: JSONDecoder())
    }
}
