//
//  KeywordUseCase.swift
//  SearchPresentation
//
//  Created by JunHyeok Lee on 7/9/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RxSwift

public protocol KeywordUseCase {
    func fetchRecentKeywords() -> Single<[String]>
    func saveRecentKeyword(_ keyword: String) -> Single<[String]>
    func deleteRecentKeyword(_ keyword: String) -> Single<[String]>
    func deleteAllRecentKeyword() -> Single<Void>
    
    func fetchRecommendKeywords() -> Single<[String]>
}
