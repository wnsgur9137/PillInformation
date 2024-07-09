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
        case loadRecentKeyword
        case search(String?)
        case didTapUserButton
        case didSelectCollectionViewItem(IndexPath)
        case didSelectTableViewRow(IndexPath)
        case didSelectTableViewDeleteButton(IndexPath)
        case didSelectTableViewDeleteAllButton
    }
    
    public enum Mutation {
        case loadedRecentKeyword
        case showSearchResultViewController(String)
        case showMyPage
        case error(Error)
    }
    
    public struct State {
        var alertContents: AlertContents?
        var reloadTableViewData: Void?
    }
    
    public var initialState = State()
    public let flowAction: SearchFlowAction
    private let recentKeywordUseCase: RecentKeywordUseCase
    private let disposeBag = DisposeBag()
    private var recentKeywords: [String] = [] {
        didSet {
            print("🚨recentKeywords: \(recentKeywords)")
        }
    }
    
    public init(with recentKeywordUseCase: RecentKeywordUseCase,
                flowAction: SearchFlowAction) {
        self.recentKeywordUseCase = recentKeywordUseCase
        self.flowAction = flowAction
    }
    
    /// 에러 핸들링
    /// - Parameter error: Error 타입
    /// - Returns: Error에 따른 알럿에서 사용할 Title, Message (title: String, message: String?)
    private func handle(_ error: Error) -> AlertContents {
        guard let error = error as? SearchError else {
            return (title: "알림",
                    message: "알 수 없는 오류가 발생했습니다.")
        }
        switch error {
        case .emptyKeyword:
            fallthrough
            
        case .tooShortKeyword:
            return (title: "알림",
                    message: "알약명을 두 글자 이상 입력해주세요.")
            
        default:
            return (title: "알림",
                    message: "서버 오류가 발생했습니다.")
            
        }
    }
    
    private func fetchRecentKeywords() -> Observable<Mutation> {
        return .create { [weak self] observable in
            guard let self = self else { return Disposables.create() }
            self.recentKeywordUseCase.fetchRecentKeywords()
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
        recentKeywordUseCase.saveRecentKeyword(keyword)
            .subscribe(onSuccess: { [weak self] keywords in
                self?.recentKeywords = keywords.reversed()
            })
            .disposed(by: disposeBag)
    }
    
    private func deleteRecentKeyword(_ keyword: String) -> Observable<Mutation> {
        return .create { [weak self] observable in
            guard let self = self else { return Disposables.create() }
            self.recentKeywordUseCase.deleteRecnetKeyword(keyword)
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
            self.recentKeywordUseCase.deleteAll()
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
        case .loadRecentKeyword:
            return fetchRecentKeywords()
            
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
            return .just(.showSearchResultViewController(""))
            
        case let .didSelectTableViewRow(indexPath):
            let keyword = recentKeywords[indexPath.row]
            saveRecentKeyword(keyword)
            return .just(.showSearchResultViewController(keyword))
            
        case let .didSelectTableViewDeleteButton(indexPath):
            let keyword = recentKeywords[indexPath.row]
            return deleteRecentKeyword(keyword)
            
        case .didSelectTableViewDeleteAllButton:
            return deleteAllRecentKeywords()
        }

    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .loadedRecentKeyword:
            state.reloadTableViewData = Void()
            
        case let .showSearchResultViewController(keyword):
            showSearchResultViewController(keyword: keyword)
            
        case let .error(error):
            state.alertContents = handle(error)
            
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
        return 5
    }
    
    public func collectionViewCellForItem(at indexPath: IndexPath) -> String {
        if indexPath.item == 2 {
            return "테스트레놀테스트레놀테스트레놀테스트레놀테스트레놀테스트레놀테스트레놀테스트레놀테스트레놀테스트레놀테스트레놀테스트레놀테스트레놀테스트레놀테스트레놀테스트레놀"
        }
        return "테스트레놀"
    }
    
    public func tableViewNumberOfRows(in section: Int) -> Int {
        return recentKeywords.count
    }
    
    public func tableViewCellForRow(at indexPath: IndexPath) -> String {
        return recentKeywords[indexPath.row]
    }
}
