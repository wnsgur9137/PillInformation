//
//  DefaultKeywordRepository.swift
//  SearchData
//
//  Created by JunHyeok Lee on 7/9/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RxSwift

import NetworkInfra
import SearchDomain

public final class DefaultKeywordRepository: KeywordRepository {
    private let networkManager: NetworkManager
    private let keywordStorage: KeywordStorage
    
    public init(networkManager: NetworkManager,
                keywordStorage: KeywordStorage = DefaultKeywordStorage()) {
        self.networkManager = networkManager
        self.keywordStorage = keywordStorage
    }
}

extension DefaultKeywordRepository {
    public func executeRecentKeywords() -> Single<[String]> {
        return keywordStorage.getRecentKeywords()
    }
    
    public func setRecentKeyword(_ keyword: String) -> Single<[String]> {
        return keywordStorage.setRecentKeyword(keyword)
    }
    
    public func deleteRecentKeyword(_ keyword: String) -> Single<[String]> {
        return keywordStorage.deleteRecentKeyword(keyword)
    }
    
    public func deleteAllRecentKeyword() -> Single<Void> {
        return keywordStorage.deleteAllRecentKeyword()
    }
    
    public func executeRecommendKeywords() -> Single<[String]> {
        return networkManager.requestRecommendKeyword()
    }
}
