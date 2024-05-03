//
//  DefaultTimerRepository.swift
//  AlarmData
//
//  Created by JunHyeok Lee on 4/25/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RxSwift

import AlarmDomain
import NetworkInfra

public final class DefaultTimerRepository: TimerRepository {
    
    private let timerStorage: TimerStorage
    
    public init(timerStorage: TimerStorage = DefaultTimerStorage()) {
        self.timerStorage = timerStorage
    }
}

extension DefaultTimerRepository {
    public func fetch(timerID: Int) -> Single<TimerDomain> {
        return timerStorage.get(timerID: timerID).map { $0.toDomain() }
    }
    
    public func fetchAll() -> Single<[TimerDomain]> {
        return timerStorage.getAll().map { $0.map { $0.toDomain() }}
    }
    
    public func fetchCount() -> Single<Int> {
        return timerStorage.getCount()
    }
    
    public func save(_ timerDomain: TimerDomain) -> Single<TimerDomain> {
        let timerDTO = TimerDTO(timerData: timerDomain)
        return timerStorage.save(response: timerDTO).map { $0.toDomain() }
    }
    
    public func update(_ timerDomain: TimerDomain) -> Single<TimerDomain> {
        let timerDTO = TimerDTO(timerData: timerDomain)
        return timerStorage.update(updatedResponse: timerDTO).map { $0.toDomain() }
    }
    
    public func delete(timerID: Int) -> Single<Void> {
        return timerStorage.delete(timerID: timerID)
    }
    
    public func deleteAll() -> Single<Void> {
        return timerStorage.deleteAll()
    }
}
