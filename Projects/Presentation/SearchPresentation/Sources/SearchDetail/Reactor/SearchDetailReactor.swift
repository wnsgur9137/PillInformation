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

public enum PillInfoType {
    case pillInfo
    case pillDescription
}

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
        case loadPillInfo(PillInfoModel, Bool)
        case popViewController
        case showImageDetailView(URL?)
        case copyPasteboard(String?)
    }
    
    public struct State {
        @Pulse var pillInfo: PillInfoModel?
        @Pulse var hasPillDescription: Bool?
        @Pulse var pasteboardString: String?
    }
    
    public var initialState = State()
    private let useCase: SearchUseCase
    private let flowAction: SearchDetailFlowAction
    private let disposeBag = DisposeBag()
    private let pillInfo: PillInfoModel
    private var pillDescription: PillDescriptionModel?
    
    public init(with useCase: SearchUseCase,
                pillInfo: PillInfoModel,
                flowAction: SearchDetailFlowAction) {
        self.useCase = useCase
        self.pillInfo = pillInfo
        self.flowAction = flowAction
    }
    
    private func getPillInfo(_ indexPath: IndexPath) -> (pillInfoType: PillInfoType, name: String?, value: String?) {
        let children = Mirror(reflecting: pillInfo).children
        let index = children.index(children.startIndex, offsetBy: indexPath.row)
        let (name, anyValue) = children[index]
        let value = anyValue as? String
        return (pillInfoType: .pillInfo, name: name, value: value)
    }
    
    private func getPillDescription(_ indexPath: IndexPath) -> (pillInfoType: PillInfoType, name: String?, value: String?)? {
        guard let pillDescription = pillDescription else { return nil }
        let children = Mirror(reflecting: pillDescription).children
        let index = children.index(children.startIndex, offsetBy: indexPath.row)
        let (name, anyValue) = children[index]
        let value = anyValue as? String
        return (pillInfoType: .pillDescription, name: name, value: value)
    }
    
    private func loadPillDescription() -> Observable<Mutation> {
        return .create() { [weak self] observable in
            guard let self = self else { return Disposables.create() }
            self.useCase.executePillDescription(self.pillInfo.medicineSeq)
                .subscribe(onSuccess: { [weak self] pillDescription in
                    guard let self = self else { return }
                    self.pillDescription = pillDescription
                    observable.onNext(.loadPillInfo(self.pillInfo, true))
                }, onFailure: { error in
                    print("error: \(error)")
                    observable.onNext(.loadPillInfo(self.pillInfo, false))
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
            let info = getPillInfo(indexPath)
            return .just(.copyPasteboard(info.value))
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case let .loadPillInfo(pillInfo, hasPillDescription):
            state.pillInfo = pillInfo
            state.hasPillDescription = hasPillDescription
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
        return pillDescription != nil ? 3 : 2
    }
    
    public func numberOfRows(in section: Int) -> Int {
        if let pillDescription = pillDescription {
            switch section {
            case 0: return 0
            case 1: return Mirror(reflecting: pillDescription).children.count
            case 2: return Mirror(reflecting: pillInfo).children.count
            default: return 0
            }
        } else {
            switch section {
            case 0: return 0
            case 1: return Mirror(reflecting: pillInfo).children.count
            default: return 0
        }
        }
    }
    
    public func viewForHeader(in section: Int) -> URL? {
        if case 0 = section {
            return URL(string: pillInfo.medicineImage)
        }
        return nil
    }
    
    public func cellForRow(at indexPath: IndexPath) -> (pillInfoType: PillInfoType, name: String?, value: String?)? {
        if pillDescription != nil {
            switch indexPath.section {
            case 1: return getPillDescription(indexPath)
            case 2: return getPillInfo(indexPath)
            default: return nil
            }
        }
        return getPillInfo(indexPath)
    }
    
    public func hasPillDescription() -> Bool {
        return pillDescription != nil
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
