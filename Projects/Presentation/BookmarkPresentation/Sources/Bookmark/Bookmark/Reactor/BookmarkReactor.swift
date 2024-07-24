//
//  BookmarkReactor.swift
//  BookmarkPresentation
//
//  Created by JunHyeok Lee on 4/18/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import ReactorKit
import RxSwift
import RxCocoa

import BasePresentation

enum BookmarkError: String, Error {
    case loadError
    case saveError
    case `default`
}

public struct BookmarkFlowAction {
    let showSearchShapeViewController: () -> Void
    let showMyPageViewController: () -> Void
    
    public init(showSearchShapeViewController: @escaping () -> Void,
                showMyPageViewController: @escaping () -> Void) {
        self.showSearchShapeViewController = showSearchShapeViewController
        self.showMyPageViewController = showMyPageViewController
    }
}

public final class BookmarkReactor: Reactor {
    typealias AlertContents = (title: String, message: String?)
    
    public enum Action {
        case loadBookmarkPills
        case didTapSearchShapeButton
        case didTapUserButton
        case didSelectRow(IndexPath)
        case didSelectBookmark(IndexPath)
        case deleteRow(IndexPath)
    }
    
    public enum Mutation {
        case loadedBookmarkPills
        case showSearchShapeViewController
        case showMyPageViewController
        case showPillDetailViewController(PillInfoModel)
        case error(Error)
    }
    
    public struct State {
        @Pulse var bookmarkPillCount: Int?
        @Pulse var alertContent: (title: String, message: String?)?
    }
    
    public var initialState = State()
    private let disposeBag = DisposeBag()
    private let flowAction: BookmarkFlowAction
    private let bookmarkUseCase: BookmarkUseCase
    private var pills: [PillInfoModel] = []
    
    public init(bookmarkUseCase: BookmarkUseCase,
                flowAction: BookmarkFlowAction) {
        self.bookmarkUseCase = bookmarkUseCase
        self.flowAction = flowAction
    }
    
    /// 에러 핸들링
    /// - Parameter error: Error 타입
    /// - Returns: Error에 따른 알럿에서 사용할 Title, Message (title: String, message: String?)
    private func handle(_ error: Error) -> AlertContents {
        guard let error = error as? BookmarkError else {
            return (title: Constants.alert, message: "")
        }
        switch error {
        case .loadError:
            return (title: Constants.alert,
                    message: Constants.Bookmark.loadErrorMessage)
        case .saveError:
            return (title: Constants.alert,
                    message: Constants.Bookmark.saveErrorMessage)
        default:
            return (title: Constants.alert,
                    message: Constants.Bookmark.serverErrorMessage)
        }
    }
    
    private func loadBookmarkedPills() -> Observable<Mutation> {
        return .create { [weak self] observable in
            guard let self = self else { return Disposables.create() }
            bookmarkUseCase.fetchPills()
                .subscribe(onSuccess: { pills in
                    self.pills = pills
                    observable.onNext(.loadedBookmarkPills)
                }, onFailure: { error in
                    observable.onNext(.error(error))
                })
                .disposed(by: self.disposeBag)
            return Disposables.create()
        }
    }
    
    private func deleteBookmark(_ indexPath: IndexPath) -> Observable<Mutation> {
        let pillSeq = pills[indexPath.row].medicineSeq
        return .create { [weak self] observable in
            guard let self = self else { return Disposables.create() }
            bookmarkUseCase.deletePill(medicineSeq: pillSeq)
                .subscribe(onSuccess: { [weak self] _ in
                    guard let self = self else { return }
                    self.pills.remove(at: indexPath.row)
                    observable.onNext(.loadedBookmarkPills)
                }, onFailure: { error in
                    observable.onNext(.error(error))
                })
                .disposed(by: self.disposeBag)
            return Disposables.create()
        }
    }
}

// MARK: - React
extension BookmarkReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .loadBookmarkPills:
            return loadBookmarkedPills()
        case .didTapSearchShapeButton:
            return .just(.showSearchShapeViewController)
        case .didTapUserButton:
            return .just(.showMyPageViewController)
        case let .didSelectRow(indexPath):
            let pillInfo = pills[indexPath.row]
            return .just(.showPillDetailViewController(pillInfo))
        case let .didSelectBookmark(indexPath):
            return deleteBookmark(indexPath)
        case let .deleteRow(indexPath):
            return deleteBookmark(indexPath)
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .loadedBookmarkPills:
            state.bookmarkPillCount = pills.count
        case .showSearchShapeViewController:
            showSearchShapeViewController()
        case .showMyPageViewController:
            showMyPageViewController()
        case let .showPillDetailViewController(pillInfo):
            showPillDetailViewController(pillInfo)
        case let .error(error):
            state.alertContent = handle(error)
        }
        return state
    }
}

// MARK: - BookmarkAdapter DataSource
extension BookmarkReactor: BookmarkAdapterDataSource {
    public func numberOfRows(in: Int) -> Int {
        return pills.count
    }
    
    public func cellForRow(at indexPath: IndexPath) -> PillInfoModel {
        return pills[indexPath.row]
    }
}

// MARK: - Flow Action
extension BookmarkReactor {
    private func showSearchShapeViewController() {
        flowAction.showSearchShapeViewController()
    }
    
    private func showMyPageViewController() {
        flowAction.showMyPageViewController()
    }
    
    private func showPillDetailViewController(_ pillInfo: PillInfoModel) {
        
    }
}
