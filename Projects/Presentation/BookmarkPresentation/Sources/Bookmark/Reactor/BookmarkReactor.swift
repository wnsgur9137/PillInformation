//
//  BookmarkReactor.swift
//  BookmarkPresentation
//
//  Created by JunHyeok Lee on 4/18/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import ReactorKit
import RxSwift
import RxCocoa

import BasePresentation

public struct BookmarkFlowAction {
    let showSearchShapeViewController: () -> Void
    let showMyPageViewController: () -> Void
    
    public init(showSearchShapeViewController: @escaping () -> Void,
                showMyPageViewController: @escaping () -> Void) {
        self.showSearchShapeViewController = showSearchShapeViewController
        self.showMyPageViewController = showMyPageViewController
    }
}

public final class BookmarkReactor: Reactor {
    public enum Action {
        case didTapSearchShapeButton
        case didTapUserButton
        case didSelectRow(IndexPath)
    }
    
    public enum Mutation {
        case showSearchShapeViewController
        case showMyPageViewController
        case showPillDetailViewController
    }
    
    public struct State {
        
    }
    
    public var initialState = State()
    private let disposeBag = DisposeBag()
    private let flowAction: BookmarkFlowAction
    
    public init(flowAction: BookmarkFlowAction) {
        self.flowAction = flowAction
    }
}

// MARK: - React
extension BookmarkReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapSearchShapeButton:
            return .just(.showSearchShapeViewController)
        case .didTapUserButton:
            return .just(.showMyPageViewController)
        case let .didSelectRow(indexPath):
            return .just(.showPillDetailViewController)
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .showSearchShapeViewController:
            showSearchShapeViewController()
        case .showMyPageViewController:
            showMyPageViewController()
        case .showPillDetailViewController:
            break
        }
        return state
    }
}

// MARK: - BookmarkAdapter DataSource
extension BookmarkReactor: BookmarkAdapterDataSource {
    public func numberOfRows(in: Int) -> Int {
        return 0
    }
    
    public func cellForRow(at indexPath: IndexPath) {
        
    }
}

// MARK: - Flow Action
extension BookmarkReactor {
    private func showSearchShapeViewController() {
        flowAction.showSearchShapeViewController()
    }
    
    private func showMyPageViewController() {
        flowAction.showMyPageViewController()
    }
}
