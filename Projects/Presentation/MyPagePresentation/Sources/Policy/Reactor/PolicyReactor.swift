//
//  PolicyReactor.swift
//  MyPagePresentation
//
//  Created by JunHyeok Lee on 6/26/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import ReactorKit
import RxSwift
import RxCocoa

import BasePresentation

public struct PolicyFlowAction {
    public init() {
        
    }
}

public final class PolicyReactor: Reactor {
    public enum Action {
        case test
    }
    
    public enum Mutation {
        case test
    }
    
    public struct State {
        
    }
    
    public var initialState = State()
    private let flowAction: PolicyFlowAction
    private let disposeBag = DisposeBag()
    
    public init(flowAction: PolicyFlowAction) {
        self.flowAction = flowAction
    }
}

// MARK: - Reactor
extension PolicyReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        default: return .just(.test)
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        default: break
        }
        return state
    }
}

// MARK: - Flow Action
extension PolicyReactor {
    
}
