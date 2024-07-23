//
//  RecommendPillUseCase.swift
//  HomePresentation
//
//  Created by JunHyeok Lee on 7/22/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RxSwift

import BasePresentation

public protocol RecommendPillUseCase {
    func executeRecommendPills() -> Single<[PillInfoModel]>
    func updatePillHits(medicineSeq: Int, medicineName: String) -> Single<PillHitsModel>
}
