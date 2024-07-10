//
//  KeywordStorage.swift
//  SearchData
//
//  Created by JunHyeok Lee on 7/8/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RxSwift

public protocol KeywordStorage {
    func getRecentKeywords() -> Single<[String]>
    func setRecentKeyword(_ keyword: String) -> Single<[String]>
    func deleteRecentKeyword(_ keyword: String) -> Single<[String]>
    func deleteAllRecentKeyword() -> Single<Void>
}
