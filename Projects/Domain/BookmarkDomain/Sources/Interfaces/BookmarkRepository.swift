//
//  BookmarkRepository.swift
//  BookmarkDomain
//
//  Created by JunHyeok Lee on 7/5/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RxSwift

import BaseDomain

public protocol BookmarkRepository {
    func executePillSeqs() -> Single<[Int]>
    func executePills() -> Single<[PillInfo]>
    func savePill(pillInfo: PillInfo) -> Single<[Int]>
    func deletePill(medicineSeq: Int) -> Single<[Int]>
    func deleteAll() -> Single<Void>
}
