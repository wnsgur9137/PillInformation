//
//  KeywordRepository.swift
//  SearchDomain
//
//  Created by JunHyeok Lee on 7/9/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RxSwift

public protocol KeywordRepository {
    func executeRecentKeywords() -> Single<[String]>
    func setRecentKeyword(_ keyword: String) -> Single<[String]>
    func deleteRecentKeyword(_ keyword: String) -> Single<[String]>
    func deleteAllRecentKeyword() -> Single<Void>
    
    func executeRecommendKeywords() -> Single<[String]>
}
