//
//  DefaultSearchDetailUseCase.swift
//  BookmarkDomain
//
//  Created by JunHyeok Lee on 7/25/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RxSwift

import BasePresentation

public final class DefaultSearchDetailUseCase: SearchDetailUseCase {
    
    private let searchDetailRepository: SearchDetailRepository
    private let disposeBag = DisposeBag()
    
    public init(with repository: SearchDetailRepository) {
        self.searchDetailRepository = repository
    }
    
}

extension DefaultSearchDetailUseCase {
    public func executePillDescription(_ medicineSeq: Int) -> Single<PillDescriptionModel?> {
        return searchDetailRepository.executePillDescription(medicineSeq).map { $0?.toModel() }
    }
}
