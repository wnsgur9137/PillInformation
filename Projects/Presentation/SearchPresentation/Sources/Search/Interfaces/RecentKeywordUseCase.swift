//
//  RecentKeywordUseCase.swift
//  SearchPresentation
//
//  Created by JunHyeok Lee on 7/9/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RxSwift

public protocol RecentKeywordUseCase {
    func fetchRecentKeywords() -> Single<[String]>
    func saveRecentKeyword(_ keyword: String) -> Single<[String]>
    func deleteRecnetKeyword(_ keyword: String) -> Single<[String]>
    func deleteAll() -> Single<Void>
}
