//
//  OnboardingPolicyReactor.swift
//  OnboardingPresentation
//
//  Created by JunHyeok Lee on 3/29/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import ReactorKit
import RxSwift
import RxCocoa

public struct OnboardingPolicyFlowAction {
    public let popViewController: (Bool) -> Void
    
    public init(popViewController: @escaping (Bool) -> Void) {
        self.popViewController = popViewController
    }
}

public final class OnboardingPolicyReactor: Reactor {
    public enum Action {
        case didTapBackwardButton
    }
    
    public enum Mutation {
        case dismiss
    }
    
    public struct State {
        
    }
    
    public var initialState = State()
    public let flowAction: OnboardingPolicyFlowAction
    private let disposeBag = DisposeBag()
    
    public init(flowAction: OnboardingPolicyFlowAction) {
        self.flowAction = flowAction
    }
    
}

// MARK: - React
extension OnboardingPolicyReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapBackwardButton: .just(.dismiss)
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .dismiss: popViewController()
        }
        return state
    }
}

// MARK: - Flow Action
extension OnboardingPolicyReactor {
    private func popViewController(animated: Bool = true) {
        flowAction.popViewController(animated)
    }
}
