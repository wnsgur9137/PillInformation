//
//  PillHitHistoryStorage.swift
//  BaseData
//
//  Created by JunHyeok Lee on 8/12/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RxSwift

public protocol PillHitHistoryStorage {
    func saveHitHistories(_ hitHistories: [Int])
    func loadHitHistories() -> [Int]
}