//
//  DefaultAlarmUseCase.swift
//  AlarmDomain
//
//  Created by JunHyeok Lee on 5/2/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RxSwift

import AlarmPresentation

public final class DefaultAlarmUseCase: AlarmUseCase {
    private let alarmRepository: AlarmRepository
    
    public init(alarmRepository: AlarmRepository) {
        self.alarmRepository = alarmRepository
    }
}

extension DefaultAlarmUseCase {
    public func save(_ alarmModel: AlarmModel) -> Single<AlarmModel> {
        let alarm = Alarm(alarmModel: alarmModel)
        return alarmRepository.save(alarm).map { $0.toModel() }
    }
    
    public func execute(alarmID: Int) -> Single<AlarmModel> {
        return alarmRepository.fetch(alarmID: alarmID).map { $0.toModel() }
    }
    
    public func executeAll() -> Single<[AlarmModel]> {
        return alarmRepository.fetchAll().map { $0.map { $0.toModel() } }
    }
    
    public func executeCount() -> Single<Int> {
        return alarmRepository.fetchCount()
    }
    
    public func update(_ alarmModel: AlarmModel) -> Single<AlarmModel> {
        let alarm = Alarm(alarmModel: alarmModel)
        return alarmRepository.update(alarm).map { $0.toModel() }
    }
    
    public func delete(_ timerID: Int) -> Single<Void> {
        return alarmRepository.delete(alarmID: timerID)
    }
    
    public func deleteAll() -> Single<Void> {
        return alarmRepository.deleteAll()
    }
}
