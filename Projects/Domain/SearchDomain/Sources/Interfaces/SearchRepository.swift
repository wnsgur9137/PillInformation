//
//  SearchRepository.swift
//  SearchDomain
//
//  Created by JunHyeok Lee on 2/27/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RxSwift

import BaseDomain

public protocol SearchRepository {
    func executePill(keyword: String) -> Single<[PillInfo]>
    func executePill(shapeInfo: PillShape) -> Single<[PillInfo]>
    func executePillDescription(_ medicineSeq: Int) -> Single<PillDescription?>
    func executePillHits(medicineSeq: Int) -> Single<PillHits>
    func postPillHits(medicineSeq: Int, medicineName: String) -> Single<PillHits>
    func saveHitHistories(_ hitHistoreis: [Int])
    func loadHitHistories() -> [Int]
}
