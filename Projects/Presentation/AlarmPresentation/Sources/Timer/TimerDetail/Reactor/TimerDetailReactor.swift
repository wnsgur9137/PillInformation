//
//  TimerDetailReactor.swift
//  AlarmPresentation
//
//  Created by JUNHYEOK LEE on 4/21/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import ReactorKit
import RxSwift
import RxCocoa

import ReactiveLibraries
import NotificationInfra

public struct TimerDetailFlowAction {
    
    public init() {
        
    }
}

public final class TimerDetailReactor: Reactor {
    public enum Action {
        case viewDidLoad
        case didTapOperationButton((title: String?, duration: TimeInterval))
        case viewWillDisappear
    }
    
    public enum Mutation {
        case skip
        case isStartedTimer(TimerModel)
        case stop
        case storageError(Error)
    }
    
    public struct State {
        @Pulse var timerData: TimerModel?
        @Pulse var isError: Error?
        @Pulse var isStarted: Bool = false
    }
    
    public var initialState = State()
    private let flowAction: TimerDetailFlowAction
    private let useCase: TimerUseCase
    private let disposeBag = DisposeBag()
    private var timerModel: TimerModel?
    private var isStarted: Bool = false
    
    public init(with useCase: TimerUseCase,
                flowAction: TimerDetailFlowAction,
                timerModel: TimerModel? = nil) {
        self.useCase = useCase
        self.flowAction = flowAction
        self.timerModel = timerModel
    }
    
    private func addNotification(_ timerModel: TimerModel) {
        guard let startedDate = timerModel.startedDate else { return }
        let targetDate = startedDate.addingTimeInterval(timerModel.duration)
        let endDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: targetDate)
        let id = NotificationIdentifier.timer(id: timerModel.id)
        NotificationService.addTriggerNotification(id: id,
                                                   title: "타이머가 종료되었어요!",
                                                   body: timerModel.title ?? "",
                                                   date: endDate,
                                                   repeats: true) { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                print("Error: \(error)")
            }
            self.deleteNotification(timerModel.id)
            guard var timerModel = self.timerModel else { return }
            timerModel.isStarted = false
            DispatchQueue.main.async {
                self.useCase.update(timerModel)
                    .subscribe(onSuccess: { [weak self] timerModel in
                        self?.timerModel = timerModel
                    })
                    .disposed(by: self.disposeBag)
            }
        }
    }
    
    private func deleteNotification(_ id: Int) {
        let id = NotificationIdentifier.timer(id: id)
        NotificationService.deletePendingNotification(id: id)
        NotificationService.deleteDeliveredNotification(id: id)
    }
    
    private func save(title: String?, 
                      duration: TimeInterval) -> Observable<Mutation> {
        if let timerModel = timerModel {
            return update(timerModel: timerModel)
        }
        return .create() { [weak self] observable in
            guard let self = self else { return Disposables.create() }
            self.useCase.executeCount()
                .subscribe(onSuccess: { [weak self] count in
                    guard let self = self else { return }
                    var timerID = count
                    if let id = self.timerModel?.id {
                        timerID = id
                    }
                    let timerModel = TimerModel(id: timerID,
                                                title: title,
                                                duration: duration,
                                                startedDate: Date(),
                                                isStarted: true)
                    self.useCase.save(timerModel)
                        .subscribe(onSuccess: { [weak self] timerModel in
                            self?.addNotification(timerModel)
                            observable.onNext(.isStartedTimer(timerModel))
                        }, onFailure: { error in
                            observable.onNext(.storageError(error))
                        })
                        .disposed(by: self.disposeBag)
                }, onFailure: { error in
                    observable.onNext(.storageError(error))
                })
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
    
    private func update(timerModel: TimerModel) -> Observable<Mutation> {
        return .create() { [weak self] observable in
            guard let self = self else { return Disposables.create() }
            self.useCase.update(timerModel)
                .subscribe(onSuccess: { [weak self] timerModel in
                    self?.addNotification(timerModel)
                    observable.onNext(.skip)
                })
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
    
    private func stop() -> Observable<Mutation> {
        guard let currentTimerModel = timerModel else {
            return .just(.stop)
        }
        let timerModel = TimerModel(id: currentTimerModel.id,
                                    title: currentTimerModel.title,
                                    duration: currentTimerModel.duration,
                                    startedDate: currentTimerModel.startedDate,
                                    isStarted: false)
        return .create() { observable in
            self.useCase.update(timerModel)
                .subscribe(onSuccess: { [weak self] timerModel in
                    self?.timerModel = timerModel
                    self?.deleteNotification(timerModel.id)
                    observable.onNext(.stop)
                }, onFailure: { error in
                    observable.onNext(.storageError(error))
                })
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
}

// MARK: - React
extension TimerDetailReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            guard let timerModel = timerModel else { return .just(.skip) }
            return .just(.isStartedTimer(timerModel))
            
        case let .didTapOperationButton((title, duration)):
            if isStarted {
                return stop()
            } else {
                return save(title: title, duration: duration)
            }
            
        case .viewWillDisappear:
            guard let timerModel = timerModel else { return .just(.skip) }
            return update(timerModel: timerModel)
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .skip:
            break
            
        case let .isStartedTimer(timerModel):
            self.timerModel = timerModel
            self.isStarted = true
            state.timerData = timerModel
            
        case .stop:
            self.isStarted = false
            state.isStarted = true
            
        case let .storageError(error):
            state.isError = error
        }
        return state
    }
}

// MARK: - Flow Action
extension TimerDetailReactor {
    
}
