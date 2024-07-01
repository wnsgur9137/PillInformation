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
    let showMyPage: () -> Void
    
    public init(showNoticeDetailViewController: @escaping (NoticeModel) -> Void,
                popViewController: @escaping (Bool) -> Void,
                showMyPage: @escaping () -> Void) {
        self.showNoticeDetailViewController = showNoticeDetailViewController
        self.popViewController = popViewController
        self.showMyPage = showMyPage
    }
}

public final class NoticeDetailReactor: Reactor {
    public enum Action {
        case loadNotice
        case loadOtherNotices
        case popViewController
        case didTapUserButton
        case didSelectNotice(IndexPath)
    }
    public enum Mutation {
        case loadNotice(NoticeModel)
        case loadOtherNotices
        case popViewController
        case showMyPage
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
            
        case .didTapUserButton:
            return .just(.showMyPage)
            
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
        case .showMyPage:
            showMyPage()
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
    
    private func showMyPage() {
        flowAction.showMyPage()
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
