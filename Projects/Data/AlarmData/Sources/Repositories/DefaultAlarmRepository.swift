//
//  DefaultAlarmRepository.swift
//  AlarmData
//
//  Created by JunHyeok Lee on 5/2/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RxSwift

import AlarmDomain
import NetworkInfra

public final class DefaultAlarmRepository: AlarmRepository {
    private let alarmStorage: AlarmStorage
    
    public init(alarmStorage: AlarmStorage = DefaultAlarmStorage()) {
        self.alarmStorage = alarmStorage
    }
}

extension DefaultAlarmRepository {
    public func save(_ alarm: Alarm) -> Single<Alarm> {
        let alarmDTO = AlarmDTO(alarm: alarm)
        return alarmStorage.save(response: alarmDTO).map { $0.toDomain() }
    }
    
    public func fetch(alarmID: Int) -> Single<Alarm> {
        return alarmStorage.get(alarmID: alarmID).map { $0.toDomain() }
    }
    
    public func fetchAll() -> Single<[Alarm]> {
        return alarmStorage.getAll().map { $0.map { $0.toDomain() } }
    }
    
    public func fetchCount() -> Single<Int> {
        return alarmStorage.getCount()
    }
    
    public func update(_ alarm: Alarm) -> Single<Alarm> {
        let updatedAlarmDTO = AlarmDTO(alarm: alarm)
        return alarmStorage.update(updatedResponse: updatedAlarmDTO).map { $0.toDomain() }
    }
    
    public func delete(alarmID: Int) -> Single<Void> {
        return alarmStorage.delete(alarmID: alarmID)
    }
    
    public func deleteAll() -> Single<Void> {
        return alarmStorage.deleteAll()
    }
}
