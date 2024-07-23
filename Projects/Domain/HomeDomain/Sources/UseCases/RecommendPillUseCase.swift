//
//  RecommendPillUseCase.swift
//  HomeDomain
//
//  Created by JunHyeok Lee on 7/22/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RxSwift

import BasePresentation
import HomePresentation

public final class DefaultRecommendPillUseCase: RecommendPillUseCase {
    private let recommendPillRepoisitory: RecommendPillRepository
    
    public init(with repoisitory: RecommendPillRepository) {
        self.recommendPillRepoisitory = repoisitory
    }
}

extension DefaultRecommendPillUseCase {
    public func executeRecommendPills() -> Single<[PillInfoModel]> {
        self.recommendPillRepoisitory.executeRecommendPills().map { $0.map { $0.toModel() }}
    }
    
    public func updatePillHits(medicineSeq: Int, medicineName: String) -> Single<PillHitsModel> {
        self.recommendPillRepoisitory.updatePillHits(medicineSeq: medicineSeq, medicineName: medicineName).map { $0.toModel() }
    }
}
