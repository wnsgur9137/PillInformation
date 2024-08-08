//
//  HomeNoticeReactor.swift
//  HomePresentation
//
//  Created by JunHyeok Lee on 8/7/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import ReactorKit
import RxSwift

public struct HomeNoticeFlowAction {
    public init() {
        
    }
}

public final class HomeNoticeReactor: Reactor {
    public enum Action {
        
    }
    
    public enum Mutation {
        
    }
    
    public struct State {
        
    }
    
    public var initialState = State()
    private let flowAction: HomeNoticeFlowAction
    
    public init(flowAction: HomeNoticeFlowAction) {
        self.flowAction = flowAction
    }
}

// MARK: - React
extension HomeNoticeReactor {
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
extension HomeNoticeReactor {
    
}
