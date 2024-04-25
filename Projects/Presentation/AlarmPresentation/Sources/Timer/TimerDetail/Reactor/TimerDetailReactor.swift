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
        case didTapOperationButton((title: String?, duration: TimeInterval))
    }
    
    public enum Mutation {
        case isStartedTimer(TimerModel)
        case stop
        case storageError(Error)
    }
    
    public struct State {
        @Pulse var timerData: RevisionedData<TimerModel?> = .init(nil)
        @Pulse var isError: RevisionedData<Error?> = .init(nil)
        @Pulse var isStarted: Bool = false
    }
    
    public var initialState = State()
    private let flowAction: TimerDetailFlowAction
    private let useCase: TimerUseCase
    private let disposeBag = DisposeBag()
    
    private var isStarted: Bool = false
    
    public init(with useCase: TimerUseCase,
                flowAction: TimerDetailFlowAction) {
        self.useCase = useCase
        self.flowAction = flowAction
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
                    print("timerModel: \(timerModel)")
                    observable.onNext(.isStartedTimer(timerModel))
                }, onFailure: { error in
                    print("error: \(error)")
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
        case let .didTapOperationButton((title, duration)):
            print("🚨isStarted: \(isStarted)")
            if isStarted {
                return .just(.stop)
            } else {
                return save(title: title, duration: duration)
            }
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case let .isStartedTimer(timerModel):
            state.timerData = state.timerData.update(timerModel)
            self.isStarted = true
        case .stop:
//            state.isStarted = state.isStarted.update(true)
            state.isStarted = true
            self.isStarted = false
        case let .storageError(error):
            state.isError = state.isError.update(error)
        }
        return state
    }
}

// MARK: - Flow Action
extension TimerDetailReactor {
    
}
