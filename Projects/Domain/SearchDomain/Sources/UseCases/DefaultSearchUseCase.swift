//
//  SearchUseCase.swift
//  SearchDomain
//
//  Created by JunHyeok Lee on 2/27/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RxSwift

import SearchPresentation

public final class DefaultSearchUseCase: SearchUseCase {
    
    private let searchRepository: SearchRepository
    
    public init(with repository: SearchRepository) {
        self.searchRepository = repository
    }
}

extension DefaultSearchUseCase {
    public func executePill(keyword: String) -> Single<[String]> {
        return searchRepository.executePill(keyword: keyword)
    }
}
