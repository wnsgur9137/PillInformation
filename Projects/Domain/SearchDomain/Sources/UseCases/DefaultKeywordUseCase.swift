//
//  DefaultKeywordUseCase.swift
//  SearchDomain
//
//  Created by JunHyeok Lee on 7/9/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RxSwift

import SearchPresentation

public final class DefaultKeywordUseCase: KeywordUseCase {
    private let keywordRepository: KeywordRepository
    
    public init(keywordRepository: KeywordRepository) {
        self.keywordRepository = keywordRepository
    }
}

extension DefaultKeywordUseCase {
    public func fetchRecentKeywords() -> Single<[String]> {
        return keywordRepository.executeRecentKeywords()
    }

    public func saveRecentKeyword(_ keyword: String) -> Single<[String]> {
        return keywordRepository.setRecentKeyword(keyword)
    }

    public func deleteRecentKeyword(_ keyword: String) -> Single<[String]> {
        return keywordRepository.deleteRecentKeyword(keyword)
    }

    public func deleteAllRecentKeyword() -> Single<Void> {
        return keywordRepository.deleteAllRecentKeyword()
    }
    
    public func fetchRecommendKeywords() -> Single<[String]> {
        return keywordRepository.executeRecommendKeywords()
    }
}
