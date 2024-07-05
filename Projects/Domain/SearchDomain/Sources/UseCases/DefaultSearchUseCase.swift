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
import BaseDomain
import BasePresentation

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
