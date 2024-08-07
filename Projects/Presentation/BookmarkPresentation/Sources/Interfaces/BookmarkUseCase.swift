//
//  BookmarkUseCase.swift
//  BookmarkPresentation
//
//  Created by JunHyeok Lee on 7/5/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RxSwift

import BasePresentation

public protocol BookmarkUseCase {
    func fetchPillSeqs () -> Single<[Int]>
    func fetchPills() -> Single<[PillInfoModel]>
    func savePill(pillInfo: PillInfoModel) -> Single<[Int]>
    func deletePill(medicineSeq: Int) -> Single<[Int]>
    func deleteAll() -> Single<Void>
}
