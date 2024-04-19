//
//  TimerReactor.swift
//  AlarmPresentation
//
//  Created by JunHyeok Lee on 4/18/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import ReactorKit
import RxSwift
import RxCocoa

public struct TimerFlowAction {
    public init() {
        
    }
}

public final class TimerReactor: Reactor {
    public enum Action {
        case viewDidLoad
    }
    
    public enum Mutation {
        case loadTimerData
    }
    
    public struct State {
        var timerCellCount: Int = 0
    }
    
    public var initialState = State()
    public let flowAction: TimerFlowAction
    private let disposeBag = DisposeBag()
    
    private var operationTimerData: [Int] = [10, 20, 30]
    private var nonOperationTimerData: [Int] = [60, 90, 120, 150, 180]
    
    public init(flowAction: TimerFlowAction) {
        self.flowAction = flowAction
    }
}

// MARK: - React
extension TimerReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return .just(.loadTimerData)
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .loadTimerData:
            state.timerCellCount = operationTimerData.count + nonOperationTimerData.count
        }
        return state
    }
}

extension TimerReactor {
    func delete(indexPath: IndexPath) {
        if indexPath.section == 0 {
            operationTimerData.remove(at: indexPath.row)
        } else if indexPath.section == 1 {
            nonOperationTimerData.remove(at: indexPath.row)
        }
    }
}

// MARK: - TimerAdapterDataSource
extension TimerReactor: TimerAdapterDataSource {
    public func numberOfRowsIn(section: Int) -> Int {
        switch section {
        case 0: return operationTimerData.count
        case 1: return nonOperationTimerData.count
        default: return 0
        }
    }
    
    public func cellForRow(at indexPath: IndexPath) {
        
    }
}

// MARK: - FlowAction
extension TimerReactor {
    
}
