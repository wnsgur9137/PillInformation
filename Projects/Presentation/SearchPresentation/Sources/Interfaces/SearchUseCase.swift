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
    // TODO: - ViewModel에서 hits를 로드하지 않고 UseCase에서 pill 정보 받아올 때 한 번에 받아오도록 수정하기
    func executePillHits(_ medicineSeq: Int) -> Single<PillHitsModel>
    func updatePillHits(medicineSeq: Int, medicineName: String) -> Single<PillHitsModel>
}
