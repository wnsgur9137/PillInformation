//
//  RecommendPillRepository.swift
//  HomeDomain
//
//  Created by JunHyeok Lee on 7/22/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RxSwift

import BaseDomain

public protocol RecommendPillRepository {
    func executeRecommendPills() -> Single<[PillInfo]>
    func updatePillHits(medicineSeq: Int, medicineName: String) -> Single<PillHits>
}
