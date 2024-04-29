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
    
    private func save(title: String?, 
                      duration: TimeInterval) -> Observable<Mutation> {
        let timerModel = TimerModel(id: 0,
                                    title: title,
                                    duration: duration,
                                    startedDate: Date(),
                                    isStarted: true)
        return .create() { observable in
            self.useCase.save(timerModel)
                .subscribe(onSuccess: { timerModel in
                    observable.onNext(.isStartedTimer(timerModel))
                }, onFailure: { error in
                    observable.onNext(.storageError(error))
                })
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
    
    private func update(timerModel: TimerModel) -> Observable<Mutation> {
        return .create() { observable in
            self.useCase.update(timerModel)
                .subscribe(onSuccess: { _ in
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
                .subscribe(onSuccess: { _ in
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
