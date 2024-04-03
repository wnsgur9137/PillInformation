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

enum SignInType {
    case apple
    case kakao
    case google
}

public struct SignInFlowAction {
    let showOnboardingPolicyViewController: () -> Void
    
    public init(showOnboardingPolicyViewController: @escaping () -> Void) {
        self.showOnboardingPolicyViewController = showOnboardingPolicyViewController
    }
}

public final class SignInReactor: Reactor {
    public enum Action {
        case didTapAppleLoginButton(String)
        case didTapKakaoLoginButton(String)
        case didTapGoogleLoginButton
    }
    
    public enum Mutation {
        case appleLogin(String)
        case kakaoLogin(String)
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
        case let .didTapAppleLoginButton(token):
            return .just(.appleLogin(token))
        case let .didTapKakaoLoginButton(token):
            return .just(.kakaoLogin(token))
        case .didTapGoogleLoginButton:
            return .just(.googleLogin)
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case let .appleLogin(token):
            showOnboardingPolicyViewController()
            
        case let .kakaoLogin(token): break
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
