//
//  DefaultSearchUseCase.swift
//  BookmarkDomain
//
//  Created by JunHyeok Lee on 7/5/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RxSwift

import BookmarkPresentation

public final class DefaultSearchUseCase: SearchUseCase {
    
    private let searchRepository: SearchRepository
    
    public init(with repository: SearchRepository) {
        self.searchRepository = repository
    }
}

extension DefaultSearchUseCase {
    public func executePill(keyword: String) -> Single<[PillInfoModel]> {
        return searchRepository.executePill(keyword: keyword).map { $0.map { $0.toModel() } }
    }
    
    public func executePillDescription(_ medicineSeq: Int) -> Single<PillDescriptionModel?> {
        return searchRepository.executePillDescription(medicineSeq).map { $0?.toModel() }
    }
}
