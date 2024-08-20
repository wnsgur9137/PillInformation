//
//  PolicyReactor.swift
//  OnboardingPresentation
//
//  Created by JunHyeok Lee on 4/2/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import ReactorKit
import RxSwift
import RxCocoa

import BasePresentation

public struct PolicyFlowAction {
    public let popViewController: (Bool) -> Void
    
    public init(popViewController: @escaping (Bool) -> Void) {
        self.popViewController = popViewController
    }
}

public final class PolicyReactor: Reactor {
    public enum PolicyType {
        case privacy
        case app
        
        var title: String {
            switch self {
            case .privacy: Constants.Onboarding.appPolicy
            case .app: Constants.Onboarding.privacyPolicyTitle
            }
        }
        
        var policy: String {
            switch self {
            case .privacy: Constants.Onboarding.appPolicy
            case .app: Constants.Onboarding.privacyPolicy
            }
        }
    }
    
    public enum Action {
        case viewDidLoad
        case didTapBackwardButton
    }
    
    public enum Mutation {
        case policy(title: String, policy: String)
        case popViewController
    }
    
    public struct State {
        var policyTitle: String?
        var policy: String?
    }
    
    public var initialState = State()
    public let flowAction: PolicyFlowAction
    private let disposeBag = DisposeBag()
    private let policyType: PolicyType
    
    public init(policyType: PolicyType,
                flowAction: PolicyFlowAction) {
        self.flowAction = flowAction
        self.policyType = policyType
    }
}

// MARK: - React
extension PolicyReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad: 
                .just(.policy(title: policyType.title, 
                              policy: policyType.policy))
            
        case .didTapBackwardButton: 
                .just(.popViewController)
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case let .policy(title, policy):
            state.policyTitle = title
            state.policy = policy
            
        case .popViewController: 
            popViewController()
        }
        return state
    }
}

// MARK: - Flow Action
extension PolicyReactor {
    private func popViewController(animated: Bool = true) {
        flowAction.popViewController(animated)
    }
}
