//
//  ImageDetailReactor.swift
//  SearchPresentation
//
//  Created by JunHyeok Lee on 5/9/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import ReactorKit
import RxSwift
import RxCocoa

public struct ImageDetailFlowAction {
    let dismiss: (Bool) -> Void
    
    public init(dismiss: @escaping (Bool) -> Void) {
        self.dismiss = dismiss
    }
}

public final class ImageDetailReactor: Reactor {
    public enum Action {
        case viewDidLoad
        case dismiss
    }
    
    public enum Mutation {
        case loadData
        case dismiss
    }
    
    public struct State {
        var imageURL: URL?
        var pillName: String?
        var className: String?
    }
    
    public var initialState = State()
    private let disposeBag = DisposeBag()
    private let flowAction: ImageDetailFlowAction
    private let pillName: String
    private let className: String?
    private let imageURL: URL
    
    public init(pillName: String,
                className: String?,
                imageURL: URL,
                flowAction: ImageDetailFlowAction) {
        self.pillName = pillName
        self.className = className
        self.imageURL = imageURL
        self.flowAction = flowAction
    }
}

// MARK: - React
extension ImageDetailReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return .just(.loadData)
        case .dismiss:
            return .just(.dismiss)
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .dismiss:
            dismiss()
        case .loadData:
            state.imageURL = imageURL
            state.pillName = pillName
            state.className = className
        }
        return state
    }
}

// MARK: - Flow Action
extension ImageDetailReactor {
    private func dismiss(animated: Bool = true) {
        flowAction.dismiss(animated)
    }
}
