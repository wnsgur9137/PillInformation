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

enum BookmarkSection: Int, CaseIterable {
    case searchTextField
    case bookmark
    case footer
}

public struct BookmarkFlowAction {
    let showSearchShapeViewController: () -> Void
    let showPillDetailViewController: (PillInfoModel) -> Void
    let showMyPageViewController: () -> Void
    
    public init(showSearchShapeViewController: @escaping () -> Void,
                showPillDetailViewController: @escaping (PillInfoModel) -> Void,
                showMyPageViewController: @escaping () -> Void) {
        self.showSearchShapeViewController = showSearchShapeViewController
        self.showPillDetailViewController = showPillDetailViewController
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
        case deleteAll
        case filtered(String?)
    }
    
    public enum Mutation {
        case loadedBookmarkPills
        case showSearchShapeViewController
        case showMyPageViewController
        case showPillDetailViewController(PillInfoModel)
        case error(Error)
        case skip
    }
    
    public struct State {
        @Pulse var pills: [BookmarkTableViewSectionModel] = []
        @Pulse var bookmarkPillCount: Int?
        @Pulse var alertContent: (title: String, message: String?)?
    }
    
    public var initialState = State()
    private let disposeBag = DisposeBag()
    private let flowAction: BookmarkFlowAction
    private let bookmarkUseCase: BookmarkUseCase
    private var pills: [PillInfoModel] = []
    private var filteredPills: [PillInfoModel] = []
    private var isFiltered: Bool = false
    
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
    
    private func deleteAll() -> Observable<Mutation> {
        return .create { [weak self] observable in
            guard let self = self else { return Disposables.create() }
            bookmarkUseCase.deleteAll()
                .subscribe(onSuccess: { [weak self] in
                    self?.pills = []
                    observable.onNext(.loadedBookmarkPills)
                }, onFailure: { error in
                    observable.onNext(.error(error))
                })
                .disposed(by: disposeBag)
            return Disposables.create()
        }
    }
    
    private func filterBookmark(_ filterText: String?) -> Observable<Mutation> {
        guard let filterText = filterText,
              filterText.count > 0 else {
            isFiltered = false
            return .just(.loadedBookmarkPills)
        }
        isFiltered = true
        filteredPills = pills.filter { pill in
            pill.medicineName.contains(filterText)
        }
        return .just(.loadedBookmarkPills)
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
        case .deleteAll:
            return deleteAll()
        case let .filtered(filterText):
            return filterBookmark(filterText)
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .loadedBookmarkPills:
            state.pills = [BookmarkTableViewSectionModel(items: pills)]
            state.bookmarkPillCount = isFiltered ? filteredPills.count : pills.count
        case .showSearchShapeViewController:
            showSearchShapeViewController()
        case .showMyPageViewController:
            showMyPageViewController()
        case let .showPillDetailViewController(pillInfo):
            showPillDetailViewController(pillInfo)
        case let .error(error):
            state.alertContent = handle(error)
        case .skip:
            break
        }
        return state
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
        flowAction.showPillDetailViewController(pillInfo)
    }
}
