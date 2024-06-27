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
        case viewDidLoad
    }
    
    public enum Mutation {
        case loadPolicy
    }
    
    public struct State {
        var url: URL?
    }
    
    public var initialState = State()
    private let flowAction: PolicyFlowAction
    private let disposeBag = DisposeBag()
    private let policyType: PolicyType
    
    public init(policyType: PolicyType,
                flowAction: PolicyFlowAction) {
        self.policyType = policyType
        self.flowAction = flowAction
    }
    
    private func loadPolicy() {
        
    }
}

// MARK: - Reactor
extension PolicyReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return .just(.loadPolicy)
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .loadPolicy:
            state.url = URL(string: "https://naver.com")
        }
        return state
    }
}

// MARK: - Flow Action
extension PolicyReactor {
    
}
