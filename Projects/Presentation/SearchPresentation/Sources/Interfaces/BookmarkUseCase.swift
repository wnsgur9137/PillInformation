//
//  BookmarkUseCase.swift
//  SearchPresentation
//
//  Created by JunHyeok Lee on 7/2/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RxSwift

import BasePresentation

public protocol BookmarkUseCase {
    func fetchPillSeqs() -> Single<[Int]>
    func savePill(pillInfo: PillInfoModel) -> Single<[Int]>
    func deletePill(medicineSeq: Int) -> Single<[Int]>
    func deleteAll() -> Single<Void>
}
