//
//  RecentKeywordRepository.swift
//  SearchDomain
//
//  Created by JunHyeok Lee on 7/9/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RxSwift

public protocol RecentKeywordRepository {
    func executeRecentKeywords() -> Single<[String]>
    func setRecentKeyword(_ keyword: String) -> Single<[String]>
    func delete(_ keyword: String) -> Single<[String]>
    func deleteAll() -> Single<Void>
}
