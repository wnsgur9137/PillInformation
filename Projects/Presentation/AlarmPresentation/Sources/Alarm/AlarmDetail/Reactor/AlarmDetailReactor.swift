//
//  AlarmDetailReactor.swift
//  AlarmPresentation
//
//  Created by JunHyeok Lee on 4/30/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import ReactorKit
import RxSwift
import RxCocoa

import NotificationInfra

public struct AlarmDetailFlowAction {
    let popViewController: (Bool) -> Void
    
    public init(popViewController: @escaping (Bool) -> Void) {
        self.popViewController = popViewController
    }
}

public final class AlarmDetailReactor: Reactor {
    public typealias AlarmData = (
        time: Date,
        title: String?,
        isSelectedDays: (
            sunday: Bool,
            monday: Bool,
            tuesday: Bool,
            wednesday: Bool,
            thursday: Bool,
            friday: Bool,
            saturday: Bool
        )
    )
    
    public enum Action {
        case viewDidLoad
        case didTapSundayButton
        case didTapMondayButton
        case didTapTuesdayButton
        case didTapWednesdayButton
        case didTapThurdayButton
        case didTapFridayButton
        case didTapSaturdayButton
        case didTapSaveButton(AlarmData)
    }
    
    public enum Mutation {
        case checkData
        case didTapWeekButton(WeekModel?)
        case popViewController
        case error(Error?)
    }
    
    public struct State {
        var alarmData: AlarmModel?
        var week: WeekModel?
        @Pulse var error: Error?
    }
    
    public var initialState = State()
    private let useCase: AlarmUseCase
    private let flowAction: AlarmDetailFlowAction
    private let disposeBag = DisposeBag()
    private var alarm: AlarmModel?
    private var week: WeekModel = WeekModel()
    
    public init(with useCase: AlarmUseCase,
                alarmModel: AlarmModel? = nil,
                flowAction: AlarmDetailFlowAction) {
        self.useCase = useCase
        self.alarm = alarmModel
        self.flowAction = flowAction
        
        if let alarmData = self.alarm {
            self.week = alarmData.week
        }
    }
    
    private func makeAlarmModel(_ alarmData: AlarmData) -> Single<AlarmModel> {
        return .create() { [weak self] single in
            guard let self = self else { return Disposables.create() }
            self.useCase.executeCount()
                .subscribe(onSuccess: { count in
                    let weekModel = WeekModel(sunday: alarmData.isSelectedDays.sunday,
                                              monday: alarmData.isSelectedDays.monday,
                                              tuesday: alarmData.isSelectedDays.tuesday,
                                              wednesday: alarmData.isSelectedDays.wednesday,
                                              thursday: alarmData.isSelectedDays.thursday,
                                              friday: alarmData.isSelectedDays.friday,
                                              saturday: alarmData.isSelectedDays.saturday)
                    let alarmModel = AlarmModel(id: count,
                                                title: alarmData.title,
                                                alarmTime: alarmData.time,
                                                week: weekModel,
                                                isActive: true)
                    single(.success(alarmModel))
                }, onFailure: { error in
                    single(.failure(error))
                })
                .disposed(by: self.disposeBag)
            return Disposables.create()
        }
    }
    
    private func save(_ alarmData: AlarmData) -> Observable<Mutation> {
        if let _ = alarm {
            return update()
        }
        
        return .create() { [weak self] observable in
            guard let self = self else { return Disposables.create() }
            self.makeAlarmModel(alarmData)
                .subscribe(onSuccess: { alarmModel in
                    self.useCase.save(alarmModel)
                        .subscribe(onSuccess: { alarmModel in
                            observable.onNext(.popViewController)
                        }, onFailure: { error in
                            observable.onNext(.error(error))
                        })
                        .disposed(by: self.disposeBag)
                }, onFailure: { error in
                    observable.onNext(.error(error))
                })
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
    
    private func update() -> Observable<Mutation> {
        return .create() { [weak self] observable in
            guard let self = self,
                  let alarm = self.alarm else { return Disposables.create() }
            self.useCase.update(alarm)
                .subscribe(onSuccess: { [weak self] alarmModel in
                    self?.alarm = alarmModel
                    observable.onNext(.popViewController)
                }, onFailure: { error in
                    observable.onNext(.error(error))
                })
                .disposed(by: self.disposeBag)
            return Disposables.create()
        }
    }
}

// MARK: - React
extension AlarmDetailReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return .just(.checkData)
            
        case .didTapSundayButton: 
            week.sunday = !week.sunday
            return .just(.didTapWeekButton(week))
            
        case .didTapMondayButton:
            week.monday = !week.monday
            return .just(.didTapWeekButton(week))
            
        case .didTapTuesdayButton:
            week.tuesday = !week.tuesday
            return .just(.didTapWeekButton(week))
            
        case .didTapWednesdayButton:
            week.wednesday = !week.wednesday
            return .just(.didTapWeekButton(week))
            
        case .didTapThurdayButton:
            week.thursday = !week.thursday
            return .just(.didTapWeekButton(week))
            
        case .didTapFridayButton:
            week.friday = !week.friday
            return .just(.didTapWeekButton(week))
            
        case .didTapSaturdayButton:
            week.saturday = !week.saturday
            return .just(.didTapWeekButton(week))
            
        case let .didTapSaveButton(alarmData):
            return save(alarmData)
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .checkData:
            state.alarmData = alarm
            
        case let .didTapWeekButton(week):
            state.week = week
            
        case .popViewController:
            popViewController()
            
        case let .error(error):
            state.error = error
        }
        return state
    }
}

// MARK: - FlowAction
extension AlarmDetailReactor {
    private func popViewController(animation: Bool = true) {
        flowAction.popViewController(animation)
    }
}
