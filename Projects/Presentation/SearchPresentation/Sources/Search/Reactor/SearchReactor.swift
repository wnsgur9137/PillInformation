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

enum SearchError: String, Error {
    case emptyKeyword
    case tooShortKeyword
    case `default`
}

public struct SearchFlowAction {
    let showSearchResultViewController: (String) -> Void
    
    public init(showSearchResultViewController: @escaping (String) -> Void) {
        self.showSearchResultViewController = showSearchResultViewController
    }
}

public final class SearchReactor: Reactor {
    typealias AlertContents = (title: String, message: String?)
    
    public enum Action {
        case search(String?)
    }
    
    public enum Mutation {
        case showSearchResultViewController(String)
        case error(Error)
    }
    
    public struct State {
        var alertContents: AlertContents?
    }
    
    public var initialState = State()
    public let flowAction: SearchFlowAction
    private let disposeBag = DisposeBag()
    
    public init(flowAction: SearchFlowAction) {
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
}

// MARK: - Reactor
extension SearchReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .search(keyword):
            guard let keyword = keyword,
                  !keyword.isEmpty else {
                return .just(.error(SearchError.emptyKeyword))
            }
            guard keyword.count >= 2 else {
                return .just(.error(SearchError.tooShortKeyword))
            }
            return .just(.showSearchResultViewController(keyword))
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case let .showSearchResultViewController(keyword):
            showSearchResultViewController(keyword: keyword)
            
        case let .error(error):
            state.alertContents = handle(error)
        }
        return state
    }
}

// MARK: - Flow Action
extension SearchReactor {
    private func showSearchResultViewController(keyword: String) {
        flowAction.showSearchResultViewController(keyword)
    }
}

// MARK: - SearchAdapter CollectionViewDataSource
extension SearchReactor: SearchCollectionViewDataSource {
    public func numberOfItemsIn(section: Int) -> Int {
        return 5
    }
    
    public func cellForItem(at indexPath: IndexPath) -> String {
        return "테스트레놀"
    }
}
