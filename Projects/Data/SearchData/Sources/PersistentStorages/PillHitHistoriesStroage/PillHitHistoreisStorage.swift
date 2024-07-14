//
//  PillHitHistoriesStorage.swift
//  SearchData
//
//  Created by JunHyeok Lee on 7/11/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RxSwift

public protocol PillHitHistoriesStorage {
    func saveHitHistories(_ hitHistories: [Int])
    func loadHitHistories() -> [Int]
}
