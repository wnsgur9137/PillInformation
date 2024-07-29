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
    let showNoticeDetailViewController: (NoticeModel) -> Void
    let showSearchDetailViewController: (PillInfoModel) -> Void
    let showSearchTab: () -> Void
    let showShapeSearchViewController: () -> Void
    let showMyPageViewController: () -> Void
    
    public init(showNoticeDetailViewController: @escaping (NoticeModel) -> Void,
                showSearchDetailViewController: @escaping (PillInfoModel) -> Void,
                showSearchTab: @escaping () -> Void,
                showShapeSearchViewController: @escaping () -> Void,
                showMyPageViewController: @escaping () -> Void) {
        self.showNoticeDetailViewController = showNoticeDetailViewController
        self.showSearchDetailViewController = showSearchDetailViewController
        self.showSearchTab = showSearchTab
        self.showShapeSearchViewController = showShapeSearchViewController
        self.showMyPageViewController = showMyPageViewController
    }
}

public final class HomeReactor: Reactor {
    public enum Action {
        case loadNotices
        case loadRecommendPills
        case didTapSearchTextField
        case didTapShapeSearchButton
        case didTapUserButton
        case didSelectNotice(IndexPath)
        case didSelectRecommendPill(IndexPath)
    }
    
    public enum Mutation {
        case isLoadedNotices
        case isLoadedRecommendPills
        case showSearchTab
        case showShapeSearch
        case showMyPage
        case showNoticeDetail(IndexPath)
        case showPillDetail(IndexPath)
        case loadError
    }
    
    public struct State {
        var isLoading: Bool = true
        @Pulse var noticeCount: Int = 0
        @Pulse var recommendPillCount: Int = 0
        var isFailedLoadNotices: Void?
    }
    
    enum HomeReactorError {
        case loadNotices
    }
    
    public var initialState = State()
    public let flowAction: HomeFlowAction
    private let disposeBag = DisposeBag()
    private let noticeUseCase: NoticeUseCase
    private let recommendPillUseCase: RecommendPillUseCase
    
    private var notices: [NoticeModel] = []
    private var recommendPills: [PillInfoModel] = []
    
    public init(noticeUseCase: NoticeUseCase,
                recommendPillUseCase: RecommendPillUseCase,
                flowAction: HomeFlowAction) {
        self.noticeUseCase = noticeUseCase
        self.recommendPillUseCase = recommendPillUseCase
        self.flowAction = flowAction
    }
    
    private func loadNotice() -> Observable<Mutation> {
        return .create() { [weak self] observable in
            guard let self = self else { return Disposables.create() }
            self.noticeUseCase.executeNotice()
                .subscribe(onSuccess: { notices in
                    self.notices = notices
                    observable.onNext(.isLoadedNotices)
                }, onFailure: { error in
                    observable.onNext(.loadError)
                })
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
    
    private func loadRecommendPills() -> Observable<Mutation> {
        return .create() { [weak self] observable in
            guard let self = self else { return Disposables.create() }
            self.recommendPillUseCase.executeRecommendPills()
                .subscribe(onSuccess: { pills in
                    self.recommendPills = pills
                    observable.onNext(.isLoadedRecommendPills)
                }, onFailure: { error in
                    observable.onNext(.loadError)
                })
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
}

// MARK: - React
extension HomeReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .loadNotices:
            return loadNotice()
        case .loadRecommendPills:
            return loadRecommendPills()
        case .didTapSearchTextField:
            return .just(.showSearchTab)
        case .didTapShapeSearchButton:
            return .just(.showShapeSearch)
        case .didTapUserButton:
            return .just(.showMyPage)
        case let .didSelectNotice(indexPath):
            return .just(.showNoticeDetail(indexPath))
        case let .didSelectRecommendPill(indexPath):
            return .just(.showPillDetail(indexPath))
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .isLoadedNotices:
            state.noticeCount = notices.count
        case .isLoadedRecommendPills:
            state.recommendPillCount = recommendPills.count
        case .showSearchTab:
            showSearchTab()
        case .showShapeSearch:
            showShapeSearchViewController()
        case .showMyPage:
            showMyPageViewController()
        case let .showNoticeDetail(indexPath):
            showNoticeDetailViewController(at: indexPath)
        case let .showPillDetail(indexPath):
            showPillDetail(at: indexPath)
        case .loadError:
            state.isFailedLoadNotices = Void()
        }
        return state
    }
}

// MARK: - Flow Action
extension HomeReactor {
    private func showNoticeDetailViewController(at indexPath: IndexPath) {
        flowAction.showNoticeDetailViewController(self.notices[indexPath.row])
    }
    
    private func showPillDetail(at indexPath: IndexPath) {
        let pillInfo = recommendPills[indexPath.item]
        flowAction.showSearchDetailViewController(pillInfo)
    }
    
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

// MARK: - HomeAdapter DataSource
extension HomeReactor: HomeAdapterDataSource {
    public func numberOfRows(in section: Int) -> Int {
        return notices.count
    }
    
    public func cellForRow(at indexPath: IndexPath) -> NoticeModel? {
        return notices[indexPath.row]
    }
    
    public func numberOfItems(in section: Int) -> Int {
        return recommendPills.count
    }
    
    public func cellForItem(at indexPath: IndexPath) -> PillInfoModel {
        return recommendPills[indexPath.item]
    }
}
