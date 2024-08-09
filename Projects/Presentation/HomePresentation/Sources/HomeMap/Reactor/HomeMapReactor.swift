//
//  HomeMapReactor.swift
//  HomePresentation
//
//  Created by JunHyeok Lee on 8/9/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import ReactorKit
import RxSwift

import BasePresentation

public struct HomeMapFlowAction {
    public init() {
        
    }
}

public final class HomeMapReactor: Reactor {
    public enum Action {
        
    }
    
    public enum Mutation {
        
    }
    
    public struct State {
        
    }
    
    public var initialState = State()
    private let flowAction: HomeMapFlowAction
    private let disposeBag = DisposeBag()
    
    public init(flowAction: HomeMapFlowAction) {
        self.flowAction = flowAction
    }
}

// MARK: - React
extension HomeMapReactor {
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

// MARK: - Flow action
extension HomeMapReactor {
    
}
