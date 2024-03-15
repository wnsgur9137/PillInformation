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
import HomeDomain

public struct NoticeDetailFlowAction {
    let showNoticeDetailViewController: (Notice) -> Void
}

public final class NoticeDetailReactor: Reactor {
    public enum Action {
        case loadNotice
        case loadOtherNotices
    }
    public enum Mutation {
        case loadNotice(Notice)
        case loadOtherNotices
    }
    public struct State {
        var notice: Notice?
        var isLoadedOtherNotices: Void = ()
    }
    
    public var initialState = State()
    public let flowAction: NoticeDetailFlowAction
    private let disposeBag = DisposeBag()
    private let noticeUseCase: NoticeUseCase
    
    private let notice: Notice
    private var otherNotices: [Notice] = []
    
    public init(notice: Notice,
                noticeUseCase: NoticeUseCase,
                flowAction: NoticeDetailFlowAction) {
        self.notice = notice
        self.noticeUseCase = noticeUseCase
        self.flowAction = flowAction
    }
    
    private func loadOtherNotices() -> Observable<[Notice]> {
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
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case let .loadNotice(notice):
            state.notice = notice
        case .loadOtherNotices:
            state.isLoadedOtherNotices = Void()
        }
        return state
    }
}

// MARK: - Flow Action
extension NoticeDetailReactor {
    func didSelectNoticeRow(at index: Int) {
        flowAction.showNoticeDetailViewController(self.otherNotices[index])
    }
}

// MARK: - NoticeDetail DataSource
extension NoticeDetailReactor: NoticeDetailAdapterDataSource {
    public func numberOfRowsIn(section: Int) -> Int {
        return otherNotices.count
    }
    
    public func cellForRow(at indexPath: IndexPath) -> HomeDomain.Notice? {
        return otherNotices[indexPath.row]
    }
}
