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
        
    }
    
    public enum Mutation {
        
    }
    
    public struct State {
        
    }
    
    public var initialState = State()
    public let flowAction: TimerFlowAction
    private let disposeBag = DisposeBag()
    
    public init(flowAction: TimerFlowAction) {
        self.flowAction = flowAction
    }
}

// MARK: - React
extension TimerReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
            
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
            
        }
        return state
    }
}

// MARK: - FlowAction
extension TimerReactor {
    
}
