//
//  PillHitHistoreisStorage.swift
//  SearchData
//
//  Created by JunHyeok Lee on 7/11/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation

public final class PillHitHistoreisStorage: PillHitHistoriesStorage {
    
    private let cache: NSCache<NSString, NSArray>
    private let hitHistoryKey: NSString = "hitHistory"
    public init() {
        cache = .init()
    }
    
    public func saveHitHistories(_ hitHistories: [Int]) {
        print("🚨\(#function) hitsHistories: \(hitHistories)")
        cache.setObject(hitHistories as NSArray, forKey: hitHistoryKey)
    }
    
    public func loadHitHistories() -> [Int] {
        print("🚨\(#function) hitsHistories: \(cache.object(forKey: hitHistoryKey) as? [Int] ?? [])")
        return cache.object(forKey: hitHistoryKey) as? [Int] ?? []
    }
}
