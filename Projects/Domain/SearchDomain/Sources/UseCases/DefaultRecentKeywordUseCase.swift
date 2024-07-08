//
//  DefaultRecentKeywordUseCase.swift
//  SearchDomain
//
//  Created by JunHyeok Lee on 7/9/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RxSwift

import SearchPresentation

public final class DefaultRecentKeywordUseCase: RecentKeywordUseCase {
    private let recentKeywordRepository: RecentKeywordRepository
    
    public init(recentKeywordRepository: RecentKeywordRepository) {
        self.recentKeywordRepository = recentKeywordRepository
    }
}

extension DefaultRecentKeywordUseCase {
    public func fetchRecentKeywords() -> Single<[String]> {
        return recentKeywordRepository.executeRecentKeywords()
    }

    public func saveRecentKeyword(_ keyword: String) -> Single<[String]> {
        return recentKeywordRepository.setRecentKeyword(keyword)
    }

    public func deleteRecnetKeyword(_ keyword: String) -> Single<[String]> {
        return recentKeywordRepository.delete(keyword)
    }

    public func deleteAll() -> Single<Void> {
        return recentKeywordRepository.deleteAll()
    }
}
