//
//  DefaultPillHitHistoryStorage.swift
//  BaseData
//
//  Created by JunHyeok Lee on 8/12/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation

public final class DefaultPillHitHistoryStorage: PillHitHistoryStorage {
    
    private let cache: NSCache<NSString, NSArray>
    private let hitHistoryKey: NSString = "hitHistory"
    public init() {
        cache = .init()
    }
    
    public func saveHitHistories(_ hitHistories: [Int]) {
        cache.setObject(hitHistories as NSArray, forKey: hitHistoryKey)
    }
    
    public func loadHitHistories() -> [Int] {
        return cache.object(forKey: hitHistoryKey) as? [Int] ?? []
    }
}
