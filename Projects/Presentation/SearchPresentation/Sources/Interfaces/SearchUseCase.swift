//
//  SearchUseCase.swift
//  SearchPresentation
//
//  Created by JunHyeok Lee on 3/21/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RxSwift

import BasePresentation

public protocol SearchUseCase {
    func executePill(keyword: String) -> Single<[PillInfoModel]>
    func executePillDescription(_ medicineSeq: Int) -> Single<PillDescriptionModel?>
    func executePillHits(_ medicineSeq: Int) -> Single<PillHitsModel>
    func updatePillHits(medicineSeq: Int, medicineName: String) -> Single<PillHitsModel>
}
