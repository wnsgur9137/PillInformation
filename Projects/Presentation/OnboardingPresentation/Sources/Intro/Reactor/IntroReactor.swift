//
//  IntroReactor.swift
//  OnboardingPresentation
//
//  Created by JunHyeok Lee on 7/19/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import ReactorKit
import RxSwift

import BasePresentation
import KakaoLibraries

public struct IntroFlowAction {
    let showOnboardingPolicyViewController: (UserModel?) -> Void
    
    public init(showOnboardingPolicyViewController: @escaping (UserModel?) -> Void) {
        self.showOnboardingPolicyViewController = showOnboardingPolicyViewController
    }
}

public final class IntroReactor: Reactor {
    public enum Action {
        case confirm
    }
    
    public enum Mutation {
        case showPolicyViewController
    }
    
    public struct State {
        
    }
    
    public var initialState = State()
    private let disposeBag = DisposeBag()
    private let flowAction: IntroFlowAction
    
    public init(flowAction: IntroFlowAction) {
        self.flowAction = flowAction
    }
}

// MARK: - React
extension IntroReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .confirm:
            return .just(.showPolicyViewController)
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        switch mutation {
        case .showPolicyViewController:
            showOnboardingPolicyViewController()
        }
        return state
    }
}

// MARK: - Flow Action
extension IntroReactor {
    private func showOnboardingPolicyViewController() {
        flowAction.showOnboardingPolicyViewController(nil)
    }
}
