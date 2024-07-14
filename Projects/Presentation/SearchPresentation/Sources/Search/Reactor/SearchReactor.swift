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

import BasePresentation

enum SearchError: String, Error {
    case emptyKeyword
    case tooShortKeyword
    case noHaveRecentKeyword
    case `default`
}

public struct SearchFlowAction {
    let showSearchResultViewController: (String) -> Void
    let showMyPage: () -> Void
    
    public init(showSearchResultViewController: @escaping (String) -> Void,
                showMyPage: @escaping () -> Void) {
        self.showSearchResultViewController = showSearchResultViewController
        self.showMyPage = showMyPage
    }
}

public final class SearchReactor: Reactor {
    typealias AlertContents = (title: String, message: String?)
    
    public enum Action {
        case loadRecommendKeyword
        case loadRecentKeyword
        case search(String?)
        case didTapUserButton
        case didSelectCollectionViewItem(IndexPath)
        case didSelectTableViewRow(IndexPath)
        case didSelectTableViewDeleteButton(IndexPath)
        case didSelectTableViewDeleteAllButton
        case deleteAllRecentKeywords
    }
    
    public enum Mutation {
        case loadedRecommendKeyword
        case loadedRecentKeyword
        case showSearchResultViewController(String)
        case showMyPage
        case showDeleteAllRecentKeywordAlert
        case error(Error)
    }
    
    public struct State {
        @Pulse var reloadCollectionViewData: Void?
        @Pulse var reloadTableViewData: Void?
        @Pulse var alertContents: AlertContents?
        @Pulse var showDeleteAllRecentKeywordAlert: Void?
    }
    
    public var initialState = State()
    public let flowAction: SearchFlowAction
    private let keywordUseCase: KeywordUseCase
    private let disposeBag = DisposeBag()
    private var recommendKeywords: [String] = []
    private var recentKeywords: [String] = []
    
    public init(with keywordUseCase: KeywordUseCase,
                flowAction: SearchFlowAction) {
        self.keywordUseCase = keywordUseCase
        self.flowAction = flowAction
    }
    
    /// 에러 핸들링
    /// - Parameter error: Error 타입
    /// - Returns: Error에 따른 알럿에서 사용할 Title, Message (title: String, message: String?)
    private func handle(_ error: Error) -> AlertContents {
        guard let error = error as? SearchError else {
            return (title: Constants.Search.alert,
                    message: Constants.Search.serverError)
        }
        switch error {
        case .emptyKeyword:
            fallthrough
            
        case .tooShortKeyword:
            return (title: Constants.Search.alert,
                    message: Constants.Search.tooShortKeywordError)
            
        case .noHaveRecentKeyword:
            return (title: Constants.Search.alert,
                    message: Constants.Search.noHaveRecentKeyword)
            
        default:
            return (title: Constants.Search.alert,
                    message: Constants.Search.serverError)
            
        }
    }
    
    private func loadRecommendKeywords() -> Observable<Mutation> {
        return .create { [weak self] observable in
            guard let self = self else { return Disposables.create() }
            keywordUseCase.fetchRecommendKeywords()
                .subscribe(onSuccess: { [weak self] keywords in
                    self?.recommendKeywords = keywords
                    observable.onNext(.loadedRecommendKeyword)
                }, onFailure: { error in
                    observable.onNext(.error(error))
                })
                .disposed(by: self.disposeBag)
            return Disposables.create()
        }
    }
    
    private func loadRecentKeywords() -> Observable<Mutation> {
        return .create { [weak self] observable in
            guard let self = self else { return Disposables.create() }
            self.keywordUseCase.fetchRecentKeywords()
                .subscribe(onSuccess: { [weak self] keywords in
                    self?.recentKeywords = keywords.reversed()
                    observable.onNext(.loadedRecentKeyword)
                }, onFailure: { error in
                    observable.onNext(.error(error))
                })
                .disposed(by: disposeBag)
            
            return Disposables.create()
        }
    }
    
    private func saveRecentKeyword(_ keyword: String) {
        keywordUseCase.saveRecentKeyword(keyword)
            .subscribe(onSuccess: { [weak self] keywords in
                self?.recentKeywords = keywords.reversed()
            })
            .disposed(by: disposeBag)
    }
    
    private func deleteRecentKeyword(_ keyword: String) -> Observable<Mutation> {
        return .create { [weak self] observable in
            guard let self = self else { return Disposables.create() }
            self.keywordUseCase.deleteRecentKeyword(keyword)
                .subscribe(onSuccess: { [weak self] keywords in
                    self?.recentKeywords = keywords.reversed()
                    observable.onNext(.loadedRecentKeyword)
                }, onFailure: { error in
                    observable.onNext(.error(error))
                })
                .disposed(by: disposeBag)
            return Disposables.create()
        }
    }
    
    private func deleteAllRecentKeywords() -> Observable<Mutation> {
        return .create { [weak self] observable in
            guard let self = self else { return Disposables.create() }
            self.keywordUseCase.deleteAllRecentKeyword()
                .subscribe(onSuccess: { [weak self] in
                    self?.recentKeywords = []
                    observable.onNext(.loadedRecentKeyword)
                }, onFailure: { error in
                    observable.onNext(.error(error))
                })
                .disposed(by: disposeBag)
            return Disposables.create()
        }
    }
}

// MARK: - Reactor
extension SearchReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .loadRecommendKeyword:
            return loadRecommendKeywords()
            
        case .loadRecentKeyword:
            return loadRecentKeywords()
            
        case let .search(keyword):
            guard let keyword = keyword,
                  !keyword.isEmpty else {
                return .just(.error(SearchError.emptyKeyword))
            }
            guard keyword.count >= 2 else {
                return .just(.error(SearchError.tooShortKeyword))
            }
            saveRecentKeyword(keyword)
            return .just(.showSearchResultViewController(keyword))
            
        case .didTapUserButton:
            return .just(.showMyPage)
            
        case let .didSelectCollectionViewItem(indexPath):
            let keyword = recommendKeywords[indexPath.item]
            saveRecentKeyword(keyword)
            return .just(.showSearchResultViewController(keyword))
            
        case let .didSelectTableViewRow(indexPath):
            let keyword = recentKeywords[indexPath.row]
            saveRecentKeyword(keyword)
            return .just(.showSearchResultViewController(keyword))
            
        case let .didSelectTableViewDeleteButton(indexPath):
            let keyword = recentKeywords[indexPath.row]
            return deleteRecentKeyword(keyword)
            
        case .didSelectTableViewDeleteAllButton:
            return recentKeywords.count > 0 ? .just(.showDeleteAllRecentKeywordAlert) : .just(.error(SearchError.noHaveRecentKeyword))
            
        case .deleteAllRecentKeywords:
            return deleteAllRecentKeywords()
        }

    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .loadedRecommendKeyword:
            state.reloadCollectionViewData = Void()
            
        case .loadedRecentKeyword:
            state.reloadTableViewData = Void()
            
        case let .showSearchResultViewController(keyword):
            showSearchResultViewController(keyword: keyword)
            
        case let .error(error):
            state.alertContents = handle(error)
            
        case .showDeleteAllRecentKeywordAlert:
            state.showDeleteAllRecentKeywordAlert = Void()
            
        case .showMyPage:
            showMyPage()
        }
        return state
    }
}

// MARK: - Flow Action
extension SearchReactor {
    private func showSearchResultViewController(keyword: String) {
        flowAction.showSearchResultViewController(keyword)
    }
    
    private func showMyPage() {
        flowAction.showMyPage()
    }
}

// MARK: - SearchAdapter DataSource
extension SearchReactor: SearchAdapterDataSource {
    public func collectionViewNumberOfItems(in section: Int) -> Int {
        return recommendKeywords.count
    }
    
    public func collectionViewCellForItem(at indexPath: IndexPath) -> String {
        return recommendKeywords[indexPath.item]
    }
    
    public func tableViewNumberOfRows(in section: Int) -> Int {
        return recentKeywords.count
    }
    
    public func tableViewCellForRow(at indexPath: IndexPath) -> String {
        return recentKeywords[indexPath.row]
    }
}
