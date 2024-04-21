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

public struct TimerDetailFlowAction {
    
    public init() {
        
    }
}

public final class TimerDetailReactor: Reactor {
    public enum Action {
        
    }
    
    public enum Mutation {
        
    }
    
    public struct State {
        
    }
    
    public var initialState = State()
    private let flowAction: TimerDetailFlowAction
    
    public init(flowAction: TimerDetailFlowAction) {
        self.flowAction = flowAction
    }
}

// MARK: - React
extension TimerDetailReactor {
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

// MARK: - Flow Action
extension TimerDetailReactor {
    
}
