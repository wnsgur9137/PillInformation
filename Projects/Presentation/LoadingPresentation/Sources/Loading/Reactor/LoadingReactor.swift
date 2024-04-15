//
//  LoadingReactor.swift
//  LoadingPresentation
//
//  Created by JunHyeok Lee on 4/12/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import ReactorKit
import RxSwift
import RxCocoa

public struct LoadingFlowAction {
    let showMainScene: () -> Void
    let showOnboardingScene: () -> Void

    public init(showMainScene: @escaping () -> Void, showOnboardingScene: @escaping () -> Void) {
        self.showMainScene = showMainScene
        self.showOnboardingScene = showOnboardingScene
    }
}

public final class LoadingReactor: Reactor {
    public enum Action {
        case viewDidLoad
    }
    
    public enum Mutation {
        case isSignin
        case isNotSignin
    }
    
    public struct State {
        
    }
    
    public var initialState = State()
    private let disposeBag = DisposeBag()
//    private let userUseCase: UserUseCase
    private let flowAction: LoadingFlowAction
    
//    public init(with useCase: UserUseCase,
//                flowAction: LoadingFlowAction) {
    public init(flowAction: LoadingFlowAction) {
//        self.userUseCase = useCase
        self.flowAction = flowAction
    }
    
    private func checkSignin() {
        
    }
}

// MARK: - React
extension LoadingReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            checkSignin()
            return .just(.isNotSignin)
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        let state = state
        switch mutation {
        case .isSignin:
            showMainScene()
            
        case .isNotSignin:
            showOnboardingScene()
        }
        return state
    }
}
// MARK: - Flow Action
extension LoadingReactor {
    private func showMainScene() {
        flowAction.showMainScene()
    }
    
    private func showOnboardingScene() {
        flowAction.showOnboardingScene()
    }
}
