//
//  SearchUseCase.swift
//  BookmarkPresentation
//
//  Created by JunHyeok Lee on 7/5/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RxSwift

public protocol SearchUseCase {
    func executePill(keyword: String) -> Single<[PillInfoModel]>
    func executePillDescription(_ medicineSeq: Int) -> Single<PillDescriptionModel?>
}