//
//  HealthReactor.swift
//  HealthPresentation
//
//  Created by JunHyeok Lee on 8/6/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import ReactorKit
import RxSwift
import RxCocoa

import BasePresentation

public struct HealthFlowAction {
    
    public init() {
        
    }
}

public final class HealthReactor: Reactor {
    public enum Action {
        
    }
    
    public enum Mutation {
        
    }
    
    public struct State {
        
    }
    
    public var initialState = State()
    public let flowAction: HealthFlowAction
    private let disposeBag = DisposeBag()
    
    public init(flowAction: HealthFlowAction) {
        self.flowAction = flowAction
    }
}

// MARK: - Reactor
extension HealthReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
            
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        switch mutation {
            
        }
    }
}

// MARK: - Flow Action
extension HealthReactor {
    
}
