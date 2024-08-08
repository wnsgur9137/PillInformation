//
//  HomeRecommendReactor.swift
//  HomePresentation
//
//  Created by JunHyeok Lee on 8/7/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import ReactorKit
import RxSwift

public struct HomeRecommendFlowAction {
    public init() {
        
    }
}

public final class HomeRecommendReactor: Reactor {
    public enum Action {
        
    }
    
    public enum Mutation {
        
    }
    
    public struct State {
        
    }
    
    public var initialState = State()
    private let flowAction: HomeRecommendFlowAction
    
    public init(flowAction: HomeRecommendFlowAction) {
        self.flowAction = flowAction
    }
}

// MARK: - React
extension HomeRecommendReactor {
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
extension HomeRecommendReactor {
    
}
