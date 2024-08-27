//
//  RealmAlarmStorage.swift
//  AlarmData
//
//  Created by JunHyeok Lee on 5/2/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift

public final class DefaultAlarmStorage {
    
    private let realm: Realm
    
    public init(testRealm: Realm? = nil) {
        if let testRealm = testRealm {
            self.realm = testRealm
            return
        }
        self.realm = try! Realm()
    }
    
    private func save(for alarmObject: AlarmObject) -> Bool {
        do {
            try realm.write {
                realm.add(alarmObject)
            }
            return true
        } catch {
            return false
        }
    }
    
    private func fetch(for id: Int) -> AlarmObject? {
        let alarmObject = realm.objects(AlarmObject.self)
        let filteredAlarmObject = alarmObject.filter("id == \(id)")
        return filteredAlarmObject.first
    }
    
    private func fetchAll() -> [AlarmObject] {
        return realm.objects(AlarmObject.self).map { $0 }
    }
    
    private func count() -> Int {
        return realm.objects(AlarmObject.self).count
    }
    
    private func update(for alarmObject: AlarmObject,
                        updatedObject: AlarmObject) -> AlarmObject? {
        guard alarmObject.id == updatedObject.id,
              let weekObject = alarmObject.week,
              let updatedWeekObject = alarmObject.week else { return nil }
        do {
            try realm.write {
                alarmObject.title = updatedObject.title
                alarmObject.alarmTime = updatedObject.alarmTime
                alarmObject.week = updatedObject.week
                alarmObject.isActive = updatedObject.isActive
            }
            try updateWeek(for: weekObject, updatedObject: updatedWeekObject)
            return fetch(for: alarmObject.id)
        } catch {
            return nil
        }
    }
    
    private func updateWeek(for weekObject: WeekObject,
                            updatedObject: WeekObject) throws {
        guard weekObject.id == updatedObject.id else {
            throw RealmError.update
        }
        try realm.write {
            weekObject.sunday = updatedObject.sunday
            weekObject.monday = updatedObject.monday
            weekObject.tuesday = updatedObject.tuesday
            weekObject.wednesday = updatedObject.wednesday
            weekObject.thursday = updatedObject.thursday
            weekObject.friday = updatedObject.friday
            weekObject.saturday = updatedObject.saturday
        }
    }
    
    private func delete(for alarmObject: AlarmObject) -> Bool {
        let weekObject = realm.objects(WeekObject.self).filter("id == \(alarmObject.id)")
        do {
            try realm.write {
                realm.delete(alarmObject)
                realm.delete(weekObject)
            }
            return true
        } catch {
            return false
        }
    }
    
    private func deleteAll() -> Bool {
        let alarmObjects = realm.objects(AlarmObject.self)
        let weekObjects = realm.objects(WeekObject.self)
        do {
            try realm.write {
                realm.delete(alarmObjects)
                realm.delete(weekObjects)
            }
            return true
        } catch {
            return false
        }
    }
}

extension DefaultAlarmStorage: AlarmStorage {
    public func save(response: AlarmDTO) -> Single<AlarmDTO> {
        if let _ = fetch(for: response.id) {
            return update(updatedResponse: response)
        }
        let alarmObject = AlarmObject(alarmDTO: response)
        guard save(for: alarmObject) else {
            return .error(RealmError.save)
        }
        return get(alarmID: response.id)
    }
    
    public func get(alarmID: Int) -> Single<AlarmDTO> {
        guard let alarmObject = fetch(for: alarmID) else {
            return .error(RealmError.fetch)
        }
        return .just(alarmObject.toDTO())
    }
    
    public func getAll() -> Single<[AlarmDTO]> {
        return .just(fetchAll().map { $0.toDTO() })
    }
    
    public func getCount() -> Single<Int> {
        return .just(count())
    }
    
    public func update(updatedResponse: AlarmDTO) -> Single<AlarmDTO> {
        guard let alarmObject = fetch(for: updatedResponse.id) else {
            return .error(RealmError.fetch)
        }
        let updateAlarmObject = AlarmObject(alarmDTO: updatedResponse)
        guard let updatedAlarmObject = update(for: alarmObject, updatedObject: updateAlarmObject) else {
            return .error(RealmError.update)
        }
        return .just(updatedAlarmObject.toDTO())
    }
    
    public func delete(alarmID: Int) -> Single<Void> {
        guard let alarmObject = fetch(for: alarmID) else {
            return .error(RealmError.fetch)
        }
        guard delete(for: alarmObject) else {
            return .error(RealmError.delete)
        }
        return .just(Void())
    }
    
    public func deleteAll() -> Single<Void> {
        guard deleteAll() else {
            return .error(RealmError.delete)
        }
        return .just(Void())
    }
}
