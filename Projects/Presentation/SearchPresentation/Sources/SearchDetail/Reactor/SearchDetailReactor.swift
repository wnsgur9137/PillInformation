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
    }
    
    public enum Mutation {
        case loadPillInfo(PillInfoModel)
        case popViewController
        case showImageDetailView(URL?)
    }
    
    public struct State {
        @Pulse var pillInfo: PillInfoModel?
    }
    
    public var initialState = State()
    private let flowAction: SearchDetailFlowAction
    private let disposeBag = DisposeBag()
    private let pillInfo: PillInfoModel
    
    public init(pillInfo: PillInfoModel,
                flowAction: SearchDetailFlowAction) {
        self.pillInfo = pillInfo
        self.flowAction = flowAction
    }
}

// MARK: - React
extension SearchDetailReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad: 
            return .just(.loadPillInfo(pillInfo))
        case .popViewController:
            return .just(.popViewController)
        case .didTapImageView:
            let url = URL(string: pillInfo.medicineImage)
            return .just(.showImageDetailView(url))
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case let .loadPillInfo(pillInfo):
            state.pillInfo = pillInfo
        case .popViewController:
            popViewController()
        case let .showImageDetailView(imageURL):
            presentImageDetailViewController(
                medicineName: pillInfo.medicineName,
                className: pillInfo.className,
                imageURL: imageURL
            )
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
        let children = Mirror(reflecting: pillInfo).children
        let index = children.index(children.startIndex, offsetBy: indexPath.row)
        let (name, anyValue) = children[index]
        let value = anyValue as? String
        return (name: name, value: value)
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
