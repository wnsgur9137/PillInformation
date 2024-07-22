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

import BasePresentation

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
    
    private var pill: PillModel
    
    public init(with useCase: SearchUseCase,
                pillInfo: PillInfoModel,
                flowAction: SearchDetailFlowAction) {
        self.pill = .init(info: pillInfo)
        self.useCase = useCase
        self.flowAction = flowAction
    }
    
    private func anyToString(_ anyValue: Any) -> String? {
        switch anyValue {
        case let stringValue as String: return stringValue
        case let intValue as Int: return "\(intValue)"
        case let floatValue as Float: return "\(floatValue)"
        default: return nil
        }
    }
    
    private func getPillInfo(_ indexPath: IndexPath, type: PillInfoType) -> (pillInfoType: PillInfoType, name: String?, value: String?)? {
        var children: Mirror.Children?
        
        switch type {
        case .pillInfo: 
            children = Mirror(reflecting: pill.info).children
        case .pillDescription:
            guard let description = pill.description else { return nil }
            children = Mirror(reflecting: description).children
        }
        
        guard let children = children else { return nil }
        let index = children.index(children.startIndex, offsetBy: indexPath.row)
        let (name, anyValue) = children[index]
        let value = anyToString(anyValue)
        return (pillInfoType: type, name: name, value: value)
    }
    
    private func getPasteboardValue(indexPath: IndexPath) -> String? {
        if pill.description != nil {
            switch indexPath.section {
            case 1: return getPillInfo(indexPath, type: .pillDescription)?.value
            case 2: return getPillInfo(indexPath, type: .pillInfo)?.value
            default: return nil
            }
        } else {
            guard indexPath.section == 1 else { return nil }
            return getPillInfo(indexPath, type: .pillInfo)?.value
        }
    }
    
    private func loadPillDescription() -> Observable<Mutation> {
        return .create() { [weak self] observable in
            guard let self = self else { return Disposables.create() }
            self.useCase.executePillDescription(self.pill.info.medicineSeq)
                .subscribe(onSuccess: { [weak self] pillDescription in
                    guard let self = self else { return }
                    guard let pillDescription = pillDescription else {
                        observable.onNext(.loadPillInfo(self.pill.info, false))
                        return
                    }
                    self.pill.addDescription(pillDescription)
                    observable.onNext(.loadPillInfo(self.pill.info, true))
                }, onFailure: { error in
                    print("error: \(error)")
                    observable.onNext(.loadPillInfo(self.pill.info, false))
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
            let url = URL(string: pill.info.medicineImage)
            return .just(.showImageDetailView(url))
        case let .didSelectRow(indexPath):
            let info = getPasteboardValue(indexPath: indexPath)
            return .just(.copyPasteboard(info))
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
                medicineName: pill.info.medicineName,
                className: pill.info.className,
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
        return pill.description != nil ? 3 : 2
    }
    
    public func numberOfRows(in section: Int) -> Int {
        if let pillDescription = pill.description {
            if case 1 = section { return Mirror(reflecting: pillDescription).children.count }
            if case 2 = section { return Mirror(reflecting: pill.info).children.count }
        } else {
            if case 1 = section { return Mirror(reflecting: pill.info).children.count }
        }
        return 0
    }
    
    public func viewForHeader(in section: Int) -> URL? {
        if case 0 = section {
            return URL(string: pill.info.medicineImage)
        }
        return nil
    }
    
    public func cellForRow(at indexPath: IndexPath) -> (pillInfoType: PillInfoType, name: String?, value: String?)? {
        guard pill.description != nil else {
            return getPillInfo(indexPath, type: .pillInfo)
        }
        switch indexPath.section {
        case 1: return getPillInfo(indexPath, type: .pillDescription)
        case 2: return getPillInfo(indexPath, type: .pillInfo)
        default: return nil
        }
    }
    
    public func hasPillDescription() -> Bool {
        return pill.description != nil
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
