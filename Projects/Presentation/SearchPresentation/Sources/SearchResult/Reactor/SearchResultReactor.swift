//
//  SearchResultReactor.swift
//  Search
//
//  Created by JunHyeok Lee on 2/26/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import ReactorKit
import RxSwift
import RxCocoa

public struct SearchResultFlowAction {
    
}

public final class SearchResultReactor: Reactor {
    public enum Action {
        case viewDidLoad
    }
    
    public enum Mutation {
        case test
    }
    
    public struct State {
        var test: Int?
    }
    
    public var initialState = State()
    public let flowAction: SearchResultFlowAction
    private let disposeBag = DisposeBag()
    
    public init(flowAction: SearchResultFlowAction) {
        self.flowAction = flowAction
    }
}

// MARK: - React
extension SearchResultReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad: return .just(.test)
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .test:
            state.test = 0
        }
        return state
    }
}

// MARK: - Flow Action
extension SearchResultReactor {
    
}

// MARK: - SearchResultAdapter DataSource
extension SearchResultReactor: SearchResultAdapterDataSource {
    public func numberOfItemsIn(section: Int) -> Int {
        return 5
    }
    
    public func cellForItem(at: IndexPath) -> Data {
        return Data()
    }
}
