//
//  BookmarkRepository.swift
//  SearchDomain
//
//  Created by JunHyeok Lee on 7/3/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RxSwift

public protocol BookmarkRepository {
    func executePillSeqs() -> Single<[Int]>
    func savePill(pillInfo: PillInfo) -> Single<[Int]>
    func deletePill(medicineSeq: Int) -> Single<[Int]>
    func deleteAll() -> Single<Void>
}
