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
    
    public init(showSearchDetailViewController: @escaping (PillInfoModel) -> Void) {
        self.showSearchDetailViewController = showSearchDetailViewController
    }
}

enum HomeRecommendSection: Int, CaseIterable {
    case pills
    case rank
    
    func title() -> String {
        switch self {
        case .pills: "많이 찾는 알약"
        case .rank: "조회수 순위"
        }
    }
}

public final class HomeRecommendReactor: Reactor {
    public enum Action {
        case loadRecommendPills
        case didSelectRecommendPills(IndexPath)
    }
    
    public enum Mutation {
        case isLoadedRecommendPills
        case loadError
        case showSearchDetail(IndexPath)
    }
    
    public struct State {
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
                    observable.onNext(.loadError)
                })
                .disposed(by: self.disposeBag)
            return Disposables.create()
        }
    }
}

// MARK: - React
extension HomeRecommendReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .loadRecommendPills:
            return loadRecommendPills()
        case let .didSelectRecommendPills(indexPath):
            return .just(.showSearchDetail(indexPath))
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .isLoadedRecommendPills:
            state.recommendPillCount = recommendPills.count
        case .loadError:
            state.isError = Void()
        case let .showSearchDetail(indexPath):
            showSearchDetail(indexPath)
        }
        return state
    }
}

// MARK: - HomeRecommend DataSource
extension HomeRecommendReactor: HomeRecommendDataSource {
    public func numberOfSection() -> Int {
//        return HomeRecommendSection.allCases.count
        return 1
    }
    
    public func numberOfItems(in section: Int) -> Int {
        guard let _ = HomeRecommendSection(rawValue: section) else { return 0 }
        return recommendPills.count
    }
    
    public func recommendSecitonItem(at indexPath: IndexPath) -> PillInfoModel? {
        guard let section = HomeRecommendSection(rawValue: indexPath.section),
              section == .pills else {
            return nil }
        return recommendPills[indexPath.item]
    }
    
    public func headerTitle(at section: Int) -> String? {
        guard let section = HomeRecommendSection(rawValue: section) else { return nil }
        return section.title()
    }
}

// MARK: - Flow action
extension HomeRecommendReactor {
    private func showSearchDetail(_ indexPath: IndexPath) {
        guard recommendPills.count >= indexPath.item else { return }
        let pill = recommendPills[indexPath.item]
        flowAction.showSearchDetailViewController(pill)
    }
}
