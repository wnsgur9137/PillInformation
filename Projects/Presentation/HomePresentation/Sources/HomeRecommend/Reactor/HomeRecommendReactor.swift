//
//  HomeRecommendReactor.swift
//  HomePresentation
//
//  Created by JunHyeok Lee on 8/7/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import ReactorKit
import RxSwift

import BasePresentation

public struct HomeRecommendFlowAction {
    let showSearchDetailViewController: (PillInfoModel) -> Void
    let showSearchTab: () -> Void
    let showShapeSearchViewController: () -> Void
    
    public init(showSearchDetailViewController: @escaping (PillInfoModel) -> Void,
                showSearchTab: @escaping () -> Void,
                showShapeSearchViewController: @escaping () -> Void) {
        self.showSearchDetailViewController = showSearchDetailViewController
        self.showSearchTab = showSearchTab
        self.showShapeSearchViewController = showShapeSearchViewController
    }
}

enum HomeRecommendSection: Int, CaseIterable {
    case shortcut
    case pills
    
    var title: String {
        switch self {
        case .shortcut: Constants.Home.searchPills
        case .pills: Constants.Home.recommendPills
        }
    }
}

public enum HomeShortcutButtonInfo: Int, CaseIterable {
    case name
    case shape
    
    var imageString: String? {
        switch self {
        case .name: return "magnifyingglass.circle.fill"
        case .shape: return "pills"
        }
    }
    
    var title: String {
        switch self {
        case .name: return Constants.Home.searchPillByNameShort
        case .shape: return Constants.Home.searchPillByShapeShort
        }
    }
}

fileprivate enum HomeRecommendReactorError: Error {
    case loadRecommendPills
    case sectionError
}

public final class HomeRecommendReactor: Reactor {
    public enum Action {
        case loadRecommendPills
        case didSelectCollecitonViewItem(IndexPath)
    }
    
    public enum Mutation {
        case isLoadedRecommendPills
        case error(Error)
        case showSearchDetail(PillInfoModel)
        case showSearchTab
        case showShapeSearch
    }
    
    public struct State {
        @Pulse var items: [RecommendCollectionViewSectionModel] = []
        var isLoading: Bool = true
        @Pulse var isError: Void?
        @Pulse var recommendPillCount: Int = 0
    }
    
    public var initialState = State()
    private let flowAction: HomeRecommendFlowAction
    private let useCase: RecommendPillUseCase
    
    private let disposeBag = DisposeBag()
    private var recommendPills: [PillInfoModel] = []
    
    public init(with useCase: RecommendPillUseCase,
                flowAction: HomeRecommendFlowAction) {
        self.useCase = useCase
        self.flowAction = flowAction
    }
    
    private func loadRecommendPills() -> Observable<Mutation> {
        return .create() { [weak self] observable in
            guard let self = self else { return Disposables.create() }
            self.useCase.executeRecommendPills()
                .subscribe(onSuccess: { [weak self] pills in
                    self?.recommendPills = pills
                    observable.onNext(.isLoadedRecommendPills)
                }, onFailure: { error in
                    print("Error: \(error)")
                    observable.onNext(.error(HomeRecommendReactorError.loadRecommendPills))
                })
                .disposed(by: self.disposeBag)
            return Disposables.create()
        }
    }
    
    private func didSelectCollectionViewItem(_ indexPath: IndexPath) -> Observable<Mutation> {
        guard let section = HomeRecommendSection(rawValue: indexPath.section) else { return .just(.error(HomeRecommendReactorError.sectionError)) }
        switch section {
        case .shortcut: return didSelectShortcutButton(indexPath.item)
        case .pills: return didSelectRecommendPillItem(indexPath.item)
        }
    }
    
    private func didSelectShortcutButton(_ item: Int) -> Observable<Mutation> {
        guard let button = HomeShortcutButtonInfo(rawValue: item) else { return .just(.error(HomeRecommendReactorError.sectionError)) }
        switch button {
        case .name: return .just(.showSearchTab)
        case .shape: return .just(.showShapeSearch)
        }
    }
    
    private func didSelectRecommendPillItem(_ item: Int) -> Observable<Mutation> {
        guard recommendPills.count >= item else { return .just(.error(HomeRecommendReactorError.sectionError)) }
        let pillInfo = recommendPills[item]
        return .just(.showSearchDetail(pillInfo))
    }
}

// MARK: - React
extension HomeRecommendReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .loadRecommendPills:
            return loadRecommendPills()
        case let .didSelectCollecitonViewItem(indexPath):
            return didSelectCollectionViewItem(indexPath)
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .isLoadedRecommendPills:
            state.items = [
                .init(
                    headerTitle: HomeRecommendSection.shortcut.title,
                    items: HomeShortcutButtonInfo.allCases.map { RecommendCollectionViewSectionModel.Item.shortcut($0) }
                ),
                .init(
                    headerTitle: HomeRecommendSection.pills.title,
                    items: recommendPills.map { RecommendCollectionViewSectionModel.Item.recommendPills($0) }
                )
            ]
            state.recommendPillCount = recommendPills.count
        case let .error(error):
            if let error = error as? HomeRecommendReactorError,
               error == .loadRecommendPills {
                state.items = [
                    .init(
                        headerTitle: HomeRecommendSection.shortcut.title,
                        items: HomeShortcutButtonInfo.allCases.map { RecommendCollectionViewSectionModel.Item.shortcut($0) }
                    ),
                ]
            }
            state.isError = Void()
        case let .showSearchDetail(pillInfo):
            showSearchDetail(pillInfo)
        case .showSearchTab:
            showSearchTab()
        case .showShapeSearch:
            showShapeSearchViewController()
        }
        return state
    }
}

// MARK: - Flow action
extension HomeRecommendReactor {
    private func showSearchDetail(_ pillInfo: PillInfoModel) {
        flowAction.showSearchDetailViewController(pillInfo)
    }
    
    private func showSearchTab() {
        flowAction.showSearchTab()
    }
    
    private func showShapeSearchViewController() {
        flowAction.showShapeSearchViewController()
    }
}
