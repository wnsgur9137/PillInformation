//
//  RealmRecentKeywordStorage.swift
//  SearchData
//
//  Created by JunHyeok Lee on 7/8/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift

import BaseData

public final class DefaultRecentKeywordStorage {
    private let realm: Realm
    
    public init() {
        self.realm = try! Realm()
    }
    
    private func save(for object: RecentKeywordObject) -> Bool {
        do {
            try realm.write {
                realm.add(object)
            }
            return true
        } catch {
            return false
        }
    }
    
    private func fetch(for keyword: String) -> RecentKeywordObject? {
        let objects = realm.objects(RecentKeywordObject.self)
        let filteredObject = objects.filter { $0.keyword == keyword }
        return filteredObject.first
    }
    
    private func fetchAll() -> [String] {
        let objects = realm.objects(RecentKeywordObject.self)
        return objects.map { $0.keyword }
    }
    
    private func fetchCount() -> Int {
        let objects = realm.objects(RecentKeywordObject.self)
        return objects.count
    }
    
    private func delete(for object: RecentKeywordObject) -> Bool {
        do {
            try realm.write {
                realm.delete(object)
            }
            return true
        } catch {
            return false
        }
    }
    
    private func deleteAll() -> Bool {
        let objects = realm.objects(RecentKeywordObject.self)
        do {
            try realm.write {
                realm.delete(objects)
            }
            return true
        } catch {
            return false
        }
    }
}

extension DefaultRecentKeywordStorage: RecentKeywordStorage {
    public func getRecentKeywords() -> Single<[String]> {
        return .just(fetchAll())
    }
    
    public func setRecentKeyword(_ keyword: String) -> Single<[String]> {
        if let object = fetch(for: keyword) {
            guard delete(for: object) else { return .error(RealmError.delete) }
        }
        let object = RecentKeywordObject(keyword: keyword)
        guard save(for: object) else { return .error(RealmError.save) }
        return .just(fetchAll())
    }
    
    public func delete(_ keyword: String) -> Single<[String]> {
        guard let object = fetch(for: keyword) else {
            return .just(fetchAll())
        }
        guard delete(for: object) else { return .error(RealmError.delete) }
        return .just(fetchAll())
    }
    
    public func deleteAll() -> Single<Void> {
        return deleteAll() ? .just(Void()) : .error(RealmError.delete)
    }
}
