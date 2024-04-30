//
//  DefaultTimerUseCase.swift
//  AlarmDomain
//
//  Created by JunHyeok Lee on 4/25/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RxSwift

import AlarmPresentation

public final class DefaultTimerUseCase: TimerUseCase {
    private let timerRepository: TimerRepository
    
    public init(with repository: TimerRepository) {
        self.timerRepository = repository
    }
}

extension DefaultTimerUseCase {
    public func save(_ timerModel: TimerModel) -> Single<TimerModel> {
        let timerDomain = TimerData(timerModel: timerModel)
        return timerRepository.save(timerDomain).map { $0.toModel() }
    }
    
    public func execute(_ timerID: Int) -> Single<TimerModel> {
        return timerRepository.fetch(timerID: timerID).map { $0.toModel() }
    }
    
    public func executeAll() -> Single<[TimerModel]> {
        return timerRepository.fetchAll().map { $0.map { $0.toModel() } }
    }
    
    public func executeCount() -> Single<Int> {
        return timerRepository.fetchCount()
    }
    
    public func update(_ timerModel: TimerModel) -> Single<TimerModel> {
        let timerDomain = TimerData(timerModel: timerModel)
        return timerRepository.update(timerDomain).map { $0.toModel() }
    }
    
    public func delete(_ timerID: Int) -> Single<Void> {
        return timerRepository.delete(timerID: timerID)
    }
    
    public func deleteAll() -> Single<Void> {
        return timerRepository.deleteAll()
    }
}
