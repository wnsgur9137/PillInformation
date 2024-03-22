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
    
    
    public init() {
        
    }
}

public final class SearchReactor: Reactor {
    public enum Action {
        case search(String)
    }
    
    public enum Mutation {
        case loadPill([String])
    }
    
    public struct State {
        var pillList: [String]?
    }
    
    public var initialState = State()
    public let flowAction: SearchFlowAction
    private let disposeBag = DisposeBag()
    private let searchUseCase: SearchUseCase
    
    public init(with useCase: SearchUseCase,
                flowAction: SearchFlowAction) {
        self.searchUseCase = useCase
        self.flowAction = flowAction
    }
    
    private func loadPillList(keyword: String) -> Observable<[String]> {
        return searchUseCase.executePill(keyword: keyword)
            .asObservable()
    }
}

// MARK: - Reactor
extension SearchReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .search(keyword):
            return loadPillList(keyword: keyword)
                .flatMap { pillList -> Observable<Mutation> in
                    return .just(.loadPill(pillList))
                }
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case let .loadPill(pillList):
            state.pillList = pillList
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
