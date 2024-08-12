//
//  SearchDetailUseCase.swift
//  SearchPresentation
//
//  Created by JunHyeok Lee on 3/21/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RxSwift

public enum SearchDetailUseCaseError: Error {
    case alreadyHits
}

public protocol SearchDetailUseCase {
    func executePillDescription(_ medicineSeq: Int) -> Single<PillDescriptionModel?>
    func fetchBookmark(medicineSeq: Int) -> Single<Bool>
    func saveBookmark(pillInfo: PillInfoModel) -> Single<Bool>
    func deleteBookmark(medicineSeq: Int) -> Single<Bool>
    func updatePillHits(medicineSeq: Int, medicineName: String) -> Single<PillHitsModel>
}
