//
//  SearchRepository.swift
//  BookmarkDomain
//
//  Created by JunHyeok Lee on 7/5/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RxSwift

public protocol SearchRepository {
    func executePill(keyword: String) -> Single<[PillInfo]>
    func executePillDescription(_ medicineSeq: Int) -> Single<PillDescription?>
}