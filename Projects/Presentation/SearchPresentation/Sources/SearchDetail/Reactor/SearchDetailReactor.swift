//
//  SearchDetailReactor.swift
//  SearchPresentation
//
//  Created by JunHyeok Lee on 5/8/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import ReactorKit
import RxSwift
import RxCocoa

public struct SearchDetailFlowAction {
    let popViewController: (Bool) -> Void
    let showImageDetailViewController: ((pillName: String, className: String?, imageURL: URL)) -> Void
    
    public init(popViewController: @escaping (Bool) -> Void,
                showImageDetailViewController: @escaping ((pillName: String, className: String?, imageURL: URL)) -> Void) {
        self.popViewController = popViewController
        self.showImageDetailViewController = showImageDetailViewController
    }
}

public final class SearchDetailReactor: Reactor {
    public enum Action {
        case viewDidLoad
        case popViewController
        case didTapImageView
        case didSelectRow(IndexPath)
    }
    
    public enum Mutation {
        case loadPillInfo(PillInfoModel, PillDescriptionModel?)
        case popViewController
        case showImageDetailView(URL?)
        case copyPasteboard(String?)
    }
    
    public struct State {
        @Pulse var pillInfo: PillInfoModel?
        @Pulse var pillDescription: PillDescriptionModel?
        @Pulse var pasteboardString: String?
    }
    
    public var initialState = State()
    private let useCase: SearchUseCase
    private let flowAction: SearchDetailFlowAction
    private let disposeBag = DisposeBag()
    private let pillInfo: PillInfoModel
    
    public init(with useCase: SearchUseCase,
                pillInfo: PillInfoModel,
                flowAction: SearchDetailFlowAction) {
        self.useCase = useCase
        self.pillInfo = pillInfo
        self.flowAction = flowAction
    }
    
    private func getInfo(_ indexPath: IndexPath) -> (name: String?, value: String?) {
        let children = Mirror(reflecting: pillInfo).children
        let index = children.index(children.startIndex, offsetBy: indexPath.row)
        let (name, anyValue) = children[index]
        let value = anyValue as? String
        return (name: name, value: value)
    }
    
    private func loadPillDescription() -> Single<PillDescriptionModel?> {
        return useCase.executePillDescription(pillInfo.medicineSeq)
    }
    
    private func loadPillDescription() -> Observable<Mutation> {
        return .create() { [weak self] observable in
            guard let self = self else { return Disposables.create() }
            self.useCase.executePillDescription(self.pillInfo.medicineSeq)
                .subscribe(onSuccess: { pillDescription in
                    observable.onNext(.loadPillInfo(self.pillInfo, pillDescription))
                }, onFailure: { error in
                    print("error: \(error)")
                    observable.onNext(.loadPillInfo(self.pillInfo, nil))
                })
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
}

// MARK: - React
extension SearchDetailReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return loadPillDescription()
        case .popViewController:
            return .just(.popViewController)
        case .didTapImageView:
            let url = URL(string: pillInfo.medicineImage)
            return .just(.showImageDetailView(url))
        case let .didSelectRow(indexPath):
            let info = getInfo(indexPath)
            return .just(.copyPasteboard(info.value))
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case let .loadPillInfo(pillInfo, pillDescription):
            state.pillInfo = pillInfo
            state.pillDescription = pillDescription
        case .popViewController:
            popViewController()
        case let .showImageDetailView(imageURL):
            presentImageDetailViewController(
                medicineName: pillInfo.medicineName,
                className: pillInfo.className,
                imageURL: imageURL
            )
        case let .copyPasteboard(value):
            state.pasteboardString = value
        }
        return state
    }
}

// MARK: - SearchDetail DataSource
extension SearchDetailReactor: SearchDetailDataSource {
    public func numberOfSection() -> Int {
        return 2
    }
    
    public func numberOfRows(in section: Int) -> Int {
        switch section {
        case 0: return 0
        case 1: return Mirror(reflecting: pillInfo).children.count
        default: return 0
        }
    }
    
    public func viewForHeader(in section: Int) -> URL? {
        switch section {
        case 0: return URL(string: pillInfo.medicineImage)
        case 1: return nil
        default: return nil
        }
    }
    
    public func cellForRow(at indexPath: IndexPath) -> (name: String?, value: String?) {
        return getInfo(indexPath)
    }
}

// MARK: - Flow Action
extension SearchDetailReactor {
    private func popViewController(animated: Bool = true) {
        flowAction.popViewController(animated)
    }
    
    private func presentImageDetailViewController(medicineName: String,
                                                  className: String?,
                                                  imageURL: URL?) {
        guard let imageURL = imageURL else { return }
        flowAction.showImageDetailViewController((
            pillName: medicineName,
            className: className,
            imageURL: imageURL
        ))
    }
}
