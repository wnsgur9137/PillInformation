//
//  SearchDetailRepository.swift
//  SearchDomain
//
//  Created by JunHyeok Lee on 8/12/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RxSwift

import BaseDomain

public protocol SearchDetailRepository {
    func executePillDescription(_ medicineSeq: Int) -> Single<PillDescription?>
    func executePillHits(medicineSeq: Int) -> Single<PillHits>
    func postPillHits(medicineSeq: Int, medicineName: String) -> Single<PillHits>
    func saveHitHistories(_ hitHistoreis: [Int])
    func loadHitHistories() -> [Int]
}
