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

public struct HomeFlowAction {
    let showNoticeDetailViewController: (NoticeModel) -> Void
    let changeTabIndex: (Int) -> Void
    
    public init(showNoticeDetailViewController: @escaping (NoticeModel) -> Void,
                changeTabIndex: @escaping (Int) -> Void) {
        self.showNoticeDetailViewController = showNoticeDetailViewController
        self.changeTabIndex = changeTabIndex
    }
}

public final class HomeReactor: Reactor {
    public enum Action {
        case loadNotices
    }
    
    public enum Mutation {
        case loadNotices
    }
    
    public struct State {
        var isLoading: Bool = true
        var isLoadedNotices: Bool = false
    }
    
    public var initialState = State()
    public let flowAction: HomeFlowAction
    private let disposeBag = DisposeBag()
    private let noticeUseCase: NoticeUseCase
    
    private var notices: [NoticeModel] = []
    
    public init(with useCase: NoticeUseCase,
                flowAction: HomeFlowAction) {
        self.noticeUseCase = useCase
        self.flowAction = flowAction
    }
    
    private func loadNotice() -> Observable<[NoticeModel]> {
        return noticeUseCase.executeNotice()
            .asObservable()
    }
}

// MARK: - React
extension HomeReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .loadNotices:
            return loadNotice()
                .flatMap { [weak self] notice -> Observable<Mutation> in
                    self?.notices = notice
                    return .just(.loadNotices)
                }
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .loadNotices:
            state.isLoadedNotices = true
        }
        return state
    }
}

// MARK: - Flow Action
extension HomeReactor {
    func didSelectNoticeRow(at index: Int) {
        flowAction.showNoticeDetailViewController(self.notices[index])
    }
    
    func changeTab(index: Int) {
        flowAction.changeTabIndex(index)
    }
}

// MARK: - HomeAdapter DataSource
extension HomeReactor: HomeAdapterDataSource {
    public func numberOfRowsIn(section: Int) -> Int {
        return notices.count
    }
    
    public func cellForRow(at indexPath: IndexPath) -> NoticeModel? {
        return notices[indexPath.row]
    }
}
