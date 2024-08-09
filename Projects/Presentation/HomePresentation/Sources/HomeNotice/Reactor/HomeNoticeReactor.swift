//
//  HomeNoticeReactor.swift
//  HomePresentation
//
//  Created by JunHyeok Lee on 8/7/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import ReactorKit
import RxSwift

public struct HomeNoticeFlowAction {
    let showNoticeDetailViewController: (NoticeModel) -> Void
    
    public init(showNoticeDetailViewController: @escaping (NoticeModel) -> Void) {
        self.showNoticeDetailViewController = showNoticeDetailViewController
    }
}

public final class HomeNoticeReactor: Reactor {
    public enum Action {
        case loadNotices
        case didSelectNotice(IndexPath)
    }
    
    public enum Mutation {
        case isLoadedNotices
        case loadError
        case showNoticeDetail(IndexPath)
    }
    
    public struct State {
        @Pulse var noticeCount: Int?
        @Pulse var isFailedLoadNotices: Void?
    }
    
    public var initialState = State()
    private let disposeBag = DisposeBag()
    private let useCase: NoticeUseCase
    private let flowAction: HomeNoticeFlowAction
    
    private var notices: [NoticeModel] = []
    
    public init(with useCase: NoticeUseCase,
                flowAction: HomeNoticeFlowAction) {
        self.useCase = useCase
        self.flowAction = flowAction
    }
    
    private func loadNotices() -> Observable<Mutation> {
        return .create() { [weak self] observable in
            guard let self = self else { return Disposables.create() }
            self.useCase.executeNotice()
                .subscribe(onSuccess: { [weak self] notices in
                    self?.notices = notices
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
extension HomeNoticeReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .loadNotices:
            return loadNotices()
            
        case let .didSelectNotice(indexPath):
            return .just(.showNoticeDetail(indexPath))
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .isLoadedNotices:
            state.noticeCount = notices.count
        case .loadError:
            state.isFailedLoadNotices = Void()
        case let .showNoticeDetail(indexPath):
            guard notices.count >= indexPath.row else { return state }
            let notice = notices[indexPath.row]
            showNoticeDetailViewController(notice)
        }
        return state
    }
}

// MARK: - HomeNotice DataSource
extension HomeNoticeReactor: HomeNoticeDataSource {
    public func numberOfRows(in section: Int) -> Int {
        return notices.count
    }
    
    public func cellForRow(at indexPath: IndexPath) -> NoticeModel? {
        guard notices.count >= indexPath.row else { return nil }
        return notices[indexPath.row]
    }
}

// MARK: - Flow action
extension HomeNoticeReactor {
    private func showNoticeDetailViewController(_ notice: NoticeModel) {
        flowAction.showNoticeDetailViewController(notice)
    }
}
