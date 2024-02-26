//
//  SearchReactor.swift
//  Search
//
//  Created by JunHyeok Lee on 2/26/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import ReactorKit
import RxSwift
import RxCocoa

public struct SearchFlowAction {
    
}

public final class SearchReactor: Reactor {
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
    public let flowAction: SearchFlowAction
    private let disposeBag = DisposeBag()
    
    public init(flowAction: SearchFlowAction) {
        self.flowAction = flowAction
    }
}

// MARK: - Reactor
extension SearchReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
                return .just(.test)
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .test:
            state.test = 1
        }
        return state
    }
}

// MARK: - Flow Action
extension SearchReactor {
    
}

// MARK: - SearchAdapter DataSource
extension SearchReactor: SearchAdapterDataSource {
    public func numberOfItemsIn(section: Int) -> Int {
        return 5
    }
    
    public func cellForItem(at indexPath: IndexPath) -> String {
        return "테스트레놀"
    }
}
