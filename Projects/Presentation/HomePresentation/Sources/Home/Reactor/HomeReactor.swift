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
    let showMyPage: () -> Void
    
    public init(showNoticeDetailViewController: @escaping (NoticeModel) -> Void,
                changeTabIndex: @escaping (Int) -> Void,
                showMyPage: @escaping () -> Void) {
        self.showNoticeDetailViewController = showNoticeDetailViewController
        self.changeTabIndex = changeTabIndex
        self.showMyPage = showMyPage
    }
}

public final class HomeReactor: Reactor {
    public enum Action {
        case loadNotices
        case changeTab(Int)
        case didTapUserButton
        case didSelectNotice(Int)
    }
    
    public enum Mutation {
        case isLoadedNotices
        case changeTab(Int)
        case showMyPage
        case showNoticeDetail(Int)
        case loadError
    }
    
    public struct State {
        var isLoading: Bool = true
        var noticeCount: Int = 0
        var isFailedLoadNotices: Void?
    }
    
    enum HomeReactorError {
        case loadNotices
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
}

// MARK: - React
extension HomeReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .loadNotices:
            return loadNotice()
        case let .changeTab(index):
            return .just(.changeTab(index))
        case .didTapUserButton:
            return .just(.showMyPage)
        case let .didSelectNotice(row):
            return .just(.showNoticeDetail(row))
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .isLoadedNotices:
            state.noticeCount = notices.count
        case let .changeTab(index):
            changeTab(index: index)
        case .showMyPage:
            showMyPage()
        case let .showNoticeDetail(row):
            didSelectNoticeRow(at: row)
        case .loadError:
            state.isFailedLoadNotices = Void()
        }
        return state
    }
}

// MARK: - Flow Action
extension HomeReactor {
    private func didSelectNoticeRow(at index: Int) {
        flowAction.showNoticeDetailViewController(self.notices[index])
    }
    
    private func changeTab(index: Int) {
        flowAction.changeTabIndex(index)
    }
    
    private func showMyPage() {
        flowAction.showMyPage()
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
}
