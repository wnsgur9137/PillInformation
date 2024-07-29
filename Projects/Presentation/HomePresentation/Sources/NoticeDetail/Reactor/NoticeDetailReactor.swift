//
//  NoticeDetailReactor.swift
//  Home
//
//  Created by JunHyeok Lee on 2/21/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import ReactorKit
import RxSwift
import RxCocoa

public struct NoticeDetailFlowAction {
    let showNoticeDetailViewController: (NoticeModel) -> Void
    let popViewController: (Bool) -> Void
    let showSearchTab: () -> Void
    let showSearchShapeViewController: () -> Void
    let showMyPageViewController: () -> Void
    
    public init(showNoticeDetailViewController: @escaping (NoticeModel) -> Void,
                popViewController: @escaping (Bool) -> Void,
                showSearchTab: @escaping () -> Void,
                showSearchShapeViewController: @escaping () -> Void,
                showMyPageViewController: @escaping () -> Void) {
        self.showNoticeDetailViewController = showNoticeDetailViewController
        self.popViewController = popViewController
        self.showSearchTab = showSearchTab
        self.showSearchShapeViewController = showSearchShapeViewController
        self.showMyPageViewController = showMyPageViewController
    }
}

public final class NoticeDetailReactor: Reactor {
    public enum Action {
        case loadNotice
        case loadOtherNotices
        case popViewController
        case didTapSearchTextField
        case didTapSearchShapeButton
        case didTapUserButton
        case didSelectNotice(IndexPath)
    }
    public enum Mutation {
        case loadNotice(NoticeModel)
        case loadOtherNotices
        case popViewController
        case showSearchTab
        case showSearchShapeViewController
        case showMyPageViewController
        case showNoticeDetail(IndexPath)
    }
    public struct State {
        var notice: NoticeModel?
        var isLoadedOtherNotices: Void = ()
    }
    
    public var initialState = State()
    public let flowAction: NoticeDetailFlowAction
    private let disposeBag = DisposeBag()
    private let noticeUseCase: NoticeUseCase
    
    private let notice: NoticeModel
    private var otherNotices: [NoticeModel] = []
    
    public init(notice: NoticeModel,
                noticeUseCase: NoticeUseCase,
                flowAction: NoticeDetailFlowAction) {
        self.notice = notice
        self.noticeUseCase = noticeUseCase
        self.flowAction = flowAction
    }
    
    private func loadOtherNotices() -> Observable<[NoticeModel]> {
        noticeUseCase.executeNotice()
            .asObservable()
    }
}
// MARK: - React
extension NoticeDetailReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .loadNotice:
            return .just(.loadNotice(self.notice))
            
        case .loadOtherNotices:
            return loadOtherNotices()
                .flatMap { [weak self] notices -> Observable<Mutation> in
                    guard let currentNotice = self?.notice else { return .just(.loadOtherNotices)}
                    let filteredNotices = notices.filter { $0.title != currentNotice.title }
                    self?.otherNotices = Array(filteredNotices.shuffled().prefix(3))
                    return .just(.loadOtherNotices)
                }
            
        case .popViewController:
            return .just(.popViewController)
            
        case .didTapSearchTextField:
            return .just(.showSearchTab)
            
        case .didTapSearchShapeButton:
            return .just(.showSearchShapeViewController)
            
        case .didTapUserButton:
            return .just(.showMyPageViewController)
            
        case let .didSelectNotice(indexPath):
            return .just(.showNoticeDetail(indexPath))
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case let .loadNotice(notice):
            state.notice = notice
        case .loadOtherNotices:
            state.isLoadedOtherNotices = Void()
        case .popViewController:
            popViewController(animated: true)
        case .showSearchTab:
            showSearchTab()
        case .showSearchShapeViewController:
            showSearchShapeViewController()
        case .showMyPageViewController:
            showMyPageViewController()
        case let .showNoticeDetail(indexPath):
            showNoticeDetailViewController(at: indexPath)
        }
        return state
    }
}

// MARK: - Flow Action
extension NoticeDetailReactor {
    private func showNoticeDetailViewController(at indexPath: IndexPath) {
        flowAction.showNoticeDetailViewController(self.otherNotices[indexPath.row])
    }
    
    private func popViewController(animated: Bool = true) {
        flowAction.popViewController(animated)
    }
    
    private func showSearchTab() {
        flowAction.showSearchTab()
    }
    
    private func showSearchShapeViewController() {
        flowAction.showSearchShapeViewController()
    }
    
    private func showMyPageViewController() {
        flowAction.showMyPageViewController()
    }
}

// MARK: - NoticeDetail DataSource
extension NoticeDetailReactor: NoticeDetailAdapterDataSource {
    public func numberOfRows(in section: Int) -> Int {
        return otherNotices.count
    }
    
    public func cellForRow(at indexPath: IndexPath) -> NoticeModel? {
        return otherNotices[indexPath.row]
    }
}
