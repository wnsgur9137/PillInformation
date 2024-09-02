//
//  HomeReactor.swift
//  Home
//
//  Created by JunHyeok Lee on 2/2/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import ReactorKit
import RxSwift
import RxCocoa

import BasePresentation

public struct HomeFlowAction {
    let showSearchTab: () -> Void
    let showShapeSearchViewController: () -> Void
    let showMyPageViewController: () -> Void
    
    public init(showSearchTab: @escaping () -> Void,
                showShapeSearchViewController: @escaping () -> Void,
                showMyPageViewController: @escaping () -> Void) {
        self.showSearchTab = showSearchTab
        self.showShapeSearchViewController = showShapeSearchViewController
        self.showMyPageViewController = showMyPageViewController
    }
}

public final class HomeReactor: Reactor {
    public enum Action {
        case didTapSearchTextField
        case didTapShapeSearchButton
        case didTapUserButton
    }
    
    public enum Mutation {
        case showSearchTab
        case showShapeSearch
        case showMyPage
    }
    
    public struct State { }
    
    public var initialState = State()
    public let flowAction: HomeFlowAction
    private let disposeBag = DisposeBag()
    
    public init(flowAction: HomeFlowAction) {
        self.flowAction = flowAction
    }
}

// MARK: - React
extension HomeReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapSearchTextField:
            return .just(.showSearchTab)
        case .didTapShapeSearchButton:
            return .just(.showShapeSearch)
        case .didTapUserButton:
            return .just(.showMyPage)
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        switch mutation {
        case .showSearchTab:
            showSearchTab()
        case .showShapeSearch:
            showShapeSearchViewController()
        case .showMyPage:
            showMyPageViewController()
        }
        return state
    }
}

// MARK: - Flow Action
extension HomeReactor {
    private func showSearchTab() {
        flowAction.showSearchTab()
    }
    
    private func showShapeSearchViewController() {
        flowAction.showShapeSearchViewController()
    }
    
    private func showMyPageViewController() {
        flowAction.showMyPageViewController()
    }
}
