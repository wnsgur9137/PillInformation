//
//  SearchResultReactor.swift
//  Search
//
//  Created by JunHyeok Lee on 2/26/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import ReactorKit
import RxSwift
import RxCocoa

import BasePresentation

public struct SearchResultFlowAction {
    let popViewController: (Bool) -> Void
    let showSearchDetailViewController: (PillInfoModel) -> Void
    let showSearchShapeViewController: () -> Void
    
    public init(popViewController: @escaping (Bool) -> Void,
                showSearchDetailViewController: @escaping (PillInfoModel) -> Void,
                showSearchShapeViewController: @escaping () -> Void) {
        self.popViewController = popViewController
        self.showSearchDetailViewController = showSearchDetailViewController
        self.showSearchShapeViewController = showSearchShapeViewController
    }
}

public final class SearchResultReactor: Reactor {
    typealias AlertContents = (title: String, message: String?)
    
    public enum Action {
        case loadPills
        case loadBookmark
        case dismiss
        case search(String?)
        case didSelectItem(IndexPath)
        case didSelectBookmark(IndexPath)
        case didTapSearchShapeButton
    }
    
    public enum Mutation {
        case dismiss
        case reloadData
        case reloadItem(IndexPath)
        case isEmptyResult
        case error(Error)
        case showSearchDetail(PillInfoModel)
        case showSearchShapeViewController
        case skip
    }
    
    public struct State {
        var keyword: String?
        @Pulse var reloadData: Void?
        @Pulse var reloadItem: IndexPath?
        @Pulse var isEmpty: Void?
        @Pulse var alertContents: AlertContents?
    }
    
    public var initialState = State()
    public let flowAction: SearchResultFlowAction
    private let searchUseCase: SearchUseCase
    private let bookmarkUseCase: BookmarkUseCase
    private var keyword: String?
    private var shapeInfo: PillShapeModel?
    private var results: [PillInfoModel] = []
    private var bookmarkSeqs: [Int] = []
    private let disposeBag = DisposeBag()
    
    public init(searchUseCase: SearchUseCase,
                bookmarkUseCase: BookmarkUseCase,
                keyword: String,
                flowAction: SearchResultFlowAction) {
        self.searchUseCase = searchUseCase
        self.bookmarkUseCase = bookmarkUseCase
        self.keyword = keyword
        self.flowAction = flowAction
    }
    
    public init(searchUseCase: SearchUseCase,
                bookmarkUseCase: BookmarkUseCase,
                shapeInfo: PillShapeModel,
                flowAction: SearchResultFlowAction) {
        self.searchUseCase = searchUseCase
        self.bookmarkUseCase = bookmarkUseCase
        self.shapeInfo = shapeInfo
        self.flowAction = flowAction
    }
    
    private func loadPills(loadPills: @escaping () -> Single<[PillInfoModel]>) -> Observable<Mutation> {
        return .create { [weak self] observable in
            guard let self = self else { return Disposables.create() }
            loadPills()
                .subscribe(onSuccess: { pills in
                    self.results = pills
                    let mutation: Mutation = pills.count > 0 ? .reloadData : .isEmptyResult
                    observable.onNext(mutation)
                }, onFailure: { error in
                    observable.onNext(.error(error))
                })
                .disposed(by: self.disposeBag)
            return Disposables.create()
        }
    }
    
    private func loadPills(keyword: String) -> Observable<Mutation> {
        return loadPills { self.searchUseCase.executePill(keyword: keyword) }
    }
    
    private func loadPills(shapeInfo: PillShapeModel) -> Observable<Mutation> {
        return loadPills { self.searchUseCase.executePill(pillShape: shapeInfo) }
    }
    
    private func loadBookmark() -> Observable<Mutation> {
        return .create() { [weak self] observable in
            guard let self = self else { return Disposables.create() }
            self.bookmarkUseCase.fetchPillSeqs()
                .subscribe(onSuccess: { seqs in
                    self.bookmarkSeqs = seqs
                    observable.onNext(.reloadData)
                }, onFailure: { error in
                    observable.onNext(.error(error))
                })
                .disposed(by: self.disposeBag)
            return Disposables.create()
        }
    }
    
    private func validate(keyword: String?) -> Error? {
        guard let keyword = keyword,
              !keyword.isEmpty else {
            return SearchError.emptyKeyword
        }
        guard keyword.count >= 2 else {
            return SearchError.tooShortKeyword
        }
        return nil
    }
    
    private func handle(_ error: Error) -> AlertContents {
        guard let error = error as? SearchError else {
            return (title: Constants.alert,
                    message: Constants.Search.serverError)
        }
        switch error {
        case .emptyKeyword:
            fallthrough
            
        case .tooShortKeyword:
            return (title: Constants.alert,
                    message: Constants.Search.tooShortKeywordError)
            
        default:
            return (title: Constants.alert,
                    message: Constants.Search.serverError)
            
        }
    }
    
    private func saveBookmark(pillInfo: PillInfoModel) -> Observable<Mutation> {
        return .create { [weak self] observable in
            guard let self = self else { return Disposables.create() }
            
            self.bookmarkUseCase.savePill(pillInfo: pillInfo)
                .subscribe(onSuccess: { seqs in
                    self.bookmarkSeqs = seqs
                    observable.onNext(.skip)
                }, onFailure: { error in
                    observable.onNext(.error(error))
                })
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
    
    private func deleteBookmark(medicineSeq: Int) -> Observable<Mutation> {
        return .create { [weak self] observable in
            guard let self = self else { return Disposables.create() }
            
            self.bookmarkUseCase.deletePill(medicineSeq: medicineSeq)
                .subscribe(onSuccess: { seqs in
                    self.bookmarkSeqs = seqs
                    observable.onNext(.skip)
                }, onFailure: { error in
                    observable.onNext(.error(error))
                })
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
    
    private func bookmark(_ indexPath: IndexPath) -> Observable<Mutation> {
        let pillInfo = results[indexPath.item]
        let isBookmarked = bookmarkSeqs.contains(pillInfo.medicineSeq)
        
        return isBookmarked ? deleteBookmark(medicineSeq: pillInfo.medicineSeq) : saveBookmark(pillInfo: pillInfo)
    }
}

// MARK: - React
extension SearchResultReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .loadPills:
            if let keyword = keyword {
                if let error = validate(keyword: keyword) {
                    return .just(.error(error))
                }
                return loadPills(keyword: keyword)
            }
            if let shapeInfo = shapeInfo {
                return loadPills(shapeInfo: shapeInfo)
            }
            return .just(.isEmptyResult)
            
        case .loadBookmark:
            return loadBookmark()
            
        case .dismiss:
            return .just(.dismiss)
            
        case let .search(keyword):
            self.keyword = keyword ?? ""
            if let error = validate(keyword: keyword) {
                return .just(.error(error))
            }
            return loadPills(keyword: keyword ?? "")
            
        case let .didSelectItem(indexPath):
            let pillInfo = results[indexPath.item]
            return .just(.showSearchDetail(pillInfo))
            
        case let .didSelectBookmark(indexPath):
            return bookmark(indexPath)
            
        case .didTapSearchShapeButton:
            return .just(.showSearchShapeViewController)
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .dismiss:
            popViewController()
            
        case .reloadData:
            state.keyword = keyword
            state.reloadData = Void()
            
        case let .reloadItem(indexPath):
            state.reloadItem = indexPath
            
        case .isEmptyResult:
            state.keyword = keyword
            state.reloadData = Void()
            state.isEmpty = Void()
            
        case let .error(error):
            state.keyword = keyword
            state.alertContents = handle(error)
            
        case let .showSearchDetail(pillInfo):
            showSearchDetailViewController(pillInfo)
            
        case .showSearchShapeViewController:
            showSearchShapeViewController()
            
        case .skip:
            break
        }
        return state
    }
}

// MARK: - Flow Action
extension SearchResultReactor {
    private func popViewController(animated: Bool = true) {
        flowAction.popViewController(animated)
    }
    
    private func showSearchDetailViewController(_ pillInfo: PillInfoModel) {
        flowAction.showSearchDetailViewController(pillInfo)
    }
    
    private func showSearchShapeViewController() {
        flowAction.showSearchShapeViewController()
    }
}

// MARK: - SearchResultAdapter DataSource
extension SearchResultReactor: SearchResultCollectionViewDataSource {
    public func numberOfItems(in section: Int) -> Int {
        return results.count
    }
    
    public func cellForItem(at indexPath: IndexPath) -> (pill: PillInfoModel, isBookmarked: Bool) {
        let pill = results[indexPath.item]
        let isBookmarked = bookmarkSeqs.contains(pill.medicineSeq)
        return (pill, isBookmarked)
    }
}
