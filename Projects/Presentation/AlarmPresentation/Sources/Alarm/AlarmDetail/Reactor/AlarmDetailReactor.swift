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

public struct AlarmDetailFlowAction {
    
    public init() {
        
    }
}

public final class AlarmDetailReactor: Reactor {
    public enum Action {
        
    }
    
    public enum Mutation {
        
    }
    
    public struct State {
        
    }
    
    public var initialState = State()
    private let flowAction: AlarmDetailFlowAction
    private let disposeBag = DisposeBag()
    private var alarmData: AlarmModel?
    
    public init(flowAction: AlarmDetailFlowAction) {
        self.flowAction = flowAction
    }
}

// MARK: - React
extension AlarmDetailReactor {
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

extension AlarmDetailReactor {
    
}

// MARK: - FlowAction
extension AlarmDetailReactor {
    
}
