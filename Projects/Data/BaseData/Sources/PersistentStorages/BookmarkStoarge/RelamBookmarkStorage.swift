//
//  RealmBookmarkStorage.swift
//  SearchData
//
//  Created by JunHyeok Lee on 7/3/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift

public final class DefaultBookmarkStorage {
    private let realm: Realm
    
    public init(testRealm: Realm? = nil) {
        if let testRealm = testRealm {
            self.realm = testRealm
            return
        }
        self.realm = try! Realm()
    }
    
    private func save(for pillInfoObject: PillInfoObject) -> Bool {
        do {
            try realm.write {
                realm.add(pillInfoObject)
            }
            return true
        } catch {
            return false
        }
    }
    
    private func fetch(for pillSeq: Int) -> PillInfoObject? {
        let pillInfoObject = realm.objects(PillInfoObject.self)
        let filteredPillInfoObject = pillInfoObject.filter("medicineSeq == \(pillSeq)")
        return filteredPillInfoObject.first
    }
    
    private func fetchSeqs() -> [Int] {
        let pillInfoObject = realm.objects(PillInfoObject.self)
        return pillInfoObject.map { $0.medicineSeq }
    }
    
    private func delete(for pillInfoObject: PillInfoObject) -> Bool {
        do {
            try realm.write {
                realm.delete(pillInfoObject)
            }
            return true
        } catch {
            return false
        }
    }
    
    private func deleteAll() -> Bool {
        let pillInfoObject = realm.objects(PillInfoObject.self)
        do {
            try realm.write {
                realm.delete(pillInfoObject)
            }
            return true
        } catch {
            return false
        }
    }
}

extension DefaultBookmarkStorage: BookmarkStorage {
    public func getPillSeqs() -> Single<[Int]> {
        return .just(fetchSeqs())
    }
    
    public func getPill(medicineSeq: Int) -> Single<PillInfoResponseDTO> {
        guard let pillInfoObject = fetch(for: medicineSeq) else {
            return .error(RealmError.fetch)
        }
        return .just(pillInfoObject.toDTO())
    }
    
    public func save(response: PillInfoResponseDTO) -> Single<[Int]> {
        if let pillInfoObject = fetch(for: response.medicineSeq) {
            return getPillSeqs()
        }
        guard save(for: PillInfoObject.makePillInfoObject(response)) else {
            return .error(RealmError.save)
        }
        return getPillSeqs()
    }
    
    public func delete(medicineSeq: Int) -> Single<[Int]> {
        guard let pillInfoObject = fetch(for: medicineSeq) else {
            return .just(fetchSeqs())
        }
        guard delete(for: pillInfoObject) else {
            return .error(RealmError.delete)
        }
        return getPillSeqs()
    }
    
    public func deleteAll() -> Single<Void> {
        return deleteAll() ? .just(Void()) : .error(RealmError.delete)
    }
}
