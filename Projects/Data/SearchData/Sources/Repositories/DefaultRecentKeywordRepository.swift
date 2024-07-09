//
//  DefaultRecentKeywordRepository.swift
//  SearchData
//
//  Created by JunHyeok Lee on 7/9/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RxSwift

import SearchDomain

public final class DefaultRecentKeywordRepository: RecentKeywordRepository {
    private let recentKeywordStorage: RecentKeywordStorage
    
    public init(recentKeywordStorage: RecentKeywordStorage = DefaultRecentKeywordStorage()) {
        self.recentKeywordStorage = recentKeywordStorage
    }
}

extension DefaultRecentKeywordRepository {
    public func executeRecentKeywords() -> Single<[String]> {
        return recentKeywordStorage.getRecentKeywords()
    }
    
    public func setRecentKeyword(_ keyword: String) -> Single<[String]> {
        return recentKeywordStorage.setRecentKeyword(keyword)
    }
    
    public func delete(_ keyword: String) -> Single<[String]> {
        return recentKeywordStorage.delete(keyword)
    }
    
    public func deleteAll() -> Single<Void> {
        return recentKeywordStorage.deleteAll()
    }
}
