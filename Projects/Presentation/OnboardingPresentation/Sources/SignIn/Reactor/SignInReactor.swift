//
//  SignInReactor.swift
//  OnboardingPresentation
//
//  Created by JunHyeok Lee on 3/28/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import ReactorKit
import RxSwift
import RxCocoa

public struct SignInFlowAction {
    let showOnboardingPolicyViewController: () -> Void
    
    public init(showOnboardingPolicyViewController: @escaping () -> Void) {
        self.showOnboardingPolicyViewController = showOnboardingPolicyViewController
    }
}

public final class SignInReactor: Reactor {
    public enum Action {
        case didTapAppleLoginButton
        case didTapKakaoLoginButton
        case didTapGoogleLoginButton
    }
    
    public enum Mutation {
        case appleLogin
        case kakaoLogin
        case googleLogin
    }
    
    public struct State {
        
    }
    
    public var initialState = State()
    private let disposeBag = DisposeBag()
    private let flowAction: SignInFlowAction
    
    public init(flowAction: SignInFlowAction) {
        self.flowAction = flowAction
    }
}

// MARK: - React
extension SignInReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapAppleLoginButton:
            return .just(.appleLogin)
        case .didTapKakaoLoginButton:
            return .just(.kakaoLogin)
        case .didTapGoogleLoginButton:
            return .just(.googleLogin)
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .appleLogin: showOnboardingPolicyViewController()
        case .kakaoLogin: break
        case .googleLogin: break
        }
        return state
    }
}

// MARK: - Flow Action
extension SignInReactor {
    private func showOnboardingPolicyViewController() {
        flowAction.showOnboardingPolicyViewController()
    }
}
