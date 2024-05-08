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

enum SearchResultError: String, Error {
    case emptyKeyword
    case tooShortKeyword
    case emptyResult
    case `default`
}

public struct SearchResultFlowAction {
    
    public init() {
        
    }
}

public final class SearchResultReactor: Reactor {
    public enum Action {
        case viewDidLoad
        case search(String?)
    }
    
    public enum Mutation {
        case reloadData
        case error(Error)
    }
    
    public struct State {
        @Pulse var reloadData: Void?
        @Pulse var error: Error?
        @Pulse var isEmpty: Void?
    }
    
    public var initialState = State()
    public let flowAction: SearchResultFlowAction
    private let searchUseCase: SearchUseCase
    private let keyword: String
    private var results: [PillInfoModel] = []
    private let disposeBag = DisposeBag()
    
    public init(with useCase: SearchUseCase,
                keyword: String,
                flowAction: SearchResultFlowAction) {
        self.searchUseCase = useCase
        self.keyword = keyword
        self.flowAction = flowAction
    }
    
    private func loadPills(keyword: String) -> Observable<Mutation> {
        return .create() { [weak self] observable in
            guard let self = self else { return Disposables.create() }
            self.searchUseCase.executePill(keyword: keyword)
                .subscribe(onSuccess: { pills in
                    self.results = pills
                    let mutation: Mutation = pills.count > 0 ? .reloadData : .error(SearchResultError.emptyResult)
                    observable.onNext(mutation)
                }, onFailure: { error in
                    observable.onNext(.error(error))
                })
                .disposed(by: self.disposeBag)
            return Disposables.create()
        }
    }
    
    private func validate(keyword: String?) -> Error? {
        guard let keyword = keyword,
              !keyword.isEmpty else {
            return SearchResultError.emptyKeyword
        }
        guard keyword.count >= 2 else {
            return SearchResultError.tooShortKeyword
        }
        return nil
    }
}

// MARK: - React
extension SearchResultReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad: 
            if let error = validate(keyword: keyword) {
                return .just(.error(error))
            }
            return loadPills(keyword: keyword)
            
        case let .search(keyword):
            if let error = validate(keyword: keyword) {
                return .just(.error(error))
            }
            return loadPills(keyword: keyword ?? "")
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .reloadData:
            state.reloadData = Void()
            
        case let .error(error):
            if case SearchResultError.emptyResult = error {
                state.isEmpty = Void()
            } else {
                state.error = error
            }
        }
        return state
    }
}

// MARK: - Flow Action
extension SearchResultReactor {
    
}

// MARK: - SearchResultAdapter DataSource
extension SearchResultReactor: SearchResultCollectionViewDataSource {
    public func numberOfItemsIn(section: Int) -> Int {
        return results.count
    }
    
    public func cellForItem(at indexPath: IndexPath) -> PillInfoModel {
        return results[indexPath.item]
    }
}
