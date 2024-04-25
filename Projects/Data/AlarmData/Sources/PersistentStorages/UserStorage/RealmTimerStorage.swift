//
//  RealmTimerStorage.swift
//  AlarmData
//
//  Created by JunHyeok Lee on 4/25/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift

enum RealmError: Error {
    case save
    case fetch
    case update
    case delete
}

public final class DefaultTimerStorage {
    
    private let realm: Realm
    
    public init() {
        self.realm = try! Realm()
        #if DEBUG
        print("🚨Realm fileURL: \(Realm.Configuration.defaultConfiguration.fileURL)")
        #endif
    }
    
    private func save(for timerObject: TimerObject) -> Bool {
        do {
            try realm.write {
                realm.add(timerObject)
            }
            return true
        } catch {
            return false
        }
    }
    
    private func fetch(for id: Int) -> TimerObject? {
        let timerObject = realm.objects(TimerObject.self)
        let filteredTimerObject = timerObject.filter("id == \(id)")
        return filteredTimerObject.first
    }
    
    private func fetchAll() -> [TimerObject] {
        return realm.objects(TimerObject.self).map{$0}
    }
    
    private func update(for timerObject: TimerObject,
                        updatedObject: TimerObject) -> TimerObject? {
        guard timerObject.id == updatedObject.id else { return nil }
        do {
            try realm.write {
                timerObject.title = updatedObject.title
                timerObject.duration = updatedObject.duration
                timerObject.startedDate = updatedObject.startedDate
                timerObject.isStarted = updatedObject.isStarted
            }
            return fetch(for: timerObject.id)
        } catch {
            return nil
        }
    }
    
    private func delete(for timerObject: TimerObject) -> Bool {
        do {
            try realm.write {
                realm.delete(timerObject)
            }
            return true
        } catch {
            return false
        }
    }
    
    private func deleteAll() -> Bool {
        let timerObjects = realm.objects(TimerObject.self)
        do {
            try realm.write {
                realm.delete(timerObjects)
            }
            return true
        } catch {
            return false
        }
    }
}

extension DefaultTimerStorage: TimerStorage {
    public func save(response: TimerDTO) -> Single<TimerDTO> {
        if let _ = fetch(for: response.id) {
            return update(updatedResponse: response)
        }
        let timerObject = TimerObject(timerDTO: response)
        guard save(for: timerObject) else {
            return .error(RealmError.save)
        }
        return get(timerID: response.id)
    }
    
    public func get(timerID: Int) -> Single<TimerDTO> {
        guard let timerObject = fetch(for: timerID) else {
            return .error(RealmError.fetch)
        }
        return .just(timerObject.toDTO())
    }
    
    public func getAll() -> Single<[TimerDTO]> {
        return .just(fetchAll().map { $0.toDTO() })
    }
    
    public func update(updatedResponse: TimerDTO) -> Single<TimerDTO> {
        guard let timerObject = fetch(for: updatedResponse.id) else {
            return .error(RealmError.fetch)
        }
        let updateTimerObject = TimerObject(timerDTO: updatedResponse)
        guard let updatedTimerObject = update(for: timerObject, updatedObject: updateTimerObject) else {
            return .error(RealmError.update)
        }
        return .just(updatedTimerObject.toDTO())
    }
    
    public func delete(timerID: Int) -> Single<Void> {
        guard let timerObject = fetch(for: timerID) else {
            return .error(RealmError.fetch)
        }
        guard delete(for: timerObject) else {
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
