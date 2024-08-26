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
    
    private func save(_ hitHistories: [Int]) {
        var object = fetch()
        object += hitHistories
        object = object.compactMap { $0 }
        cache.setObject(object as NSArray, forKey: hitHistoryKey)
    }
    
    private func fetch() -> [Int] {
        return cache.object(forKey: hitHistoryKey) as? [Int] ?? []
    }
    
    private func delete(_ hit: Int) {
        var object = fetch()
        guard let index = object.firstIndex(of: hit) else { return }
        object.remove(at: index)
        cache.setObject(object as NSArray, forKey: hitHistoryKey)
    }
    
    private func delete() {
        cache.setObject(NSArray(), forKey: hitHistoryKey)
    }
}
    
extension DefaultPillHitHistoryStorage {
    public func saveHitHistories(_ hitHistories: [Int]) -> [Int] {
        save(hitHistories)
        return fetch()
    }
    
    public func loadHitHistories() -> [Int] {
        return cache.object(forKey: hitHistoryKey) as? [Int] ?? []
    }
    
    public func deleteHitHistory(_ hit: Int) -> [Int] {
        delete(hit)
        return fetch()
    }
    
    public func deleteAll() {
        return delete()
    }
}
