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

import BasePresentation

public struct SearchResultFlowAction {
    let popViewController: (Bool) -> Void
    let showSearchDetailViewController: (PillInfoModel) -> Void
    
    public init(popViewController: @escaping (Bool) -> Void,
                showSearchDetailViewController: @escaping (PillInfoModel) -> Void) {
        self.popViewController = popViewController
        self.showSearchDetailViewController = showSearchDetailViewController
    }
}

public final class SearchResultReactor: Reactor {
    typealias AlertContents = (title: String, message: String?)
    
    public enum Action {
        case viewDidLoad
        case dismiss
        case search(String?)
        case didSelectItem(IndexPath)
    }
    
    public enum Mutation {
        case dismiss
        case reloadData
        case isEmptyResult
        case error(Error)
        case showSearchDetail(PillInfoModel)
    }
    
    public struct State {
        var keyword: String?
        @Pulse var reloadData: Void?
        @Pulse var isEmpty: Void?
        @Pulse var alertContents: AlertContents?
    }
    
    public var initialState = State()
    public let flowAction: SearchResultFlowAction
    private let searchUseCase: SearchUseCase
    private var keyword: String
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
                    let mutation: Mutation = pills.count > 0 ? .reloadData : .isEmptyResult
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
            return SearchError.emptyKeyword
        }
        guard keyword.count >= 2 else {
            return SearchError.tooShortKeyword
        }
        return nil
    }
    
    private func handle(_ error: Error) -> AlertContents {
        guard let error = error as? SearchError else {
            return (title: Constants.Search.alert,
                    message: Constants.Search.unknownError)
        }
        switch error {
        case .emptyKeyword:
            fallthrough
            
        case .tooShortKeyword:
            return (title: Constants.Search.alert,
                    message: Constants.Search.tooShortKeywordError)
            
        default:
            return (title: Constants.Search.alert,
                    message: Constants.Search.serverError)
            
        }
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
            
        case .dismiss:
            return .just(.dismiss)
            
        case let .search(keyword):
            self.keyword = keyword ?? ""
            if let error = validate(keyword: keyword) {
                return .just(.error(error))
            }
            return loadPills(keyword: keyword ?? "")
            
        case let .didSelectItem(indexPath):
            return .just(.showSearchDetail(results[indexPath.item]))
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .dismiss:
            popViewController()
            
        case .reloadData:
            state.keyword = keyword
            state.reloadData = Void()
            
        case .isEmptyResult:
            state.reloadData = Void()
            state.isEmpty = Void()
            
        case let .error(error):
            state.keyword = keyword
            state.alertContents = handle(error)
            
        case let .showSearchDetail(pillInfo):
            showSearchDetailViewController(pillInfo)
        }
        return state
    }
}

// MARK: - Flow Action
extension SearchResultReactor {
    private func popViewController(animated: Bool = true) {
        flowAction.popViewController(animated)
    }
    
    private func showSearchDetailViewController(_ pillInfo: PillInfoModel) {
        flowAction.showSearchDetailViewController(pillInfo)
    }
}

// MARK: - SearchResultAdapter DataSource
extension SearchResultReactor: SearchResultCollectionViewDataSource {
    public func numberOfItems(in section: Int) -> Int {
        return results.count
    }
    
    public func cellForItem(at indexPath: IndexPath) -> PillInfoModel {
        return results[indexPath.item]
    }
}
