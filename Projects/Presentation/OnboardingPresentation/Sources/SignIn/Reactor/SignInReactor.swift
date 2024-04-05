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

import KakaoLibraries

public enum SignInType {
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
        case didTapKakaoLoginButton
        case didTapGoogleLoginButton
    }
    
    public enum Mutation {
        case appleLogin(String)
        case kakaoLogin(String)
        case googleLogin
        case signInError(SignInType)
    }
    
    public struct State {
        var signInError: SignInType?
    }
    
    public var initialState = State()
    private let disposeBag = DisposeBag()
    private let flowAction: SignInFlowAction
    
    public init(flowAction: SignInFlowAction) {
        self.flowAction = flowAction
    }
    
    private func isKakaoLoginAvailable() -> Bool {
        return KakaoService.isKakaoTalkLoginAvailable()
    }
    
    private func loginWithKakaoTalk() -> Observable<Mutation> {
        return Observable<Mutation>.create { observable in
            KakaoService.loginWithKakaoTalk()
                .subscribe(onSuccess: { accessToken in
                    observable.onNext(.kakaoLogin(accessToken))
                }, onFailure: { error in
                    observable.onNext(.signInError(.kakao))
                })
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
    
    private func loginWithKakaoAccount() -> Observable<Mutation> {
        return Observable<Mutation>.create { observable in
            KakaoService.loginWithKakaoAccount()
                .subscribe(onSuccess: { accessToken in
                    observable.onNext(.kakaoLogin(accessToken))
                }, onFailure: { error in
                    observable.onNext(.signInError(.kakao))
                })
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
}

// MARK: - React
extension SignInReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .didTapAppleLoginButton(token):
            return .just(.appleLogin(token))
            
        case .didTapKakaoLoginButton:
            return isKakaoLoginAvailable() ? loginWithKakaoTalk() : loginWithKakaoAccount()
            
        case .didTapGoogleLoginButton:
            return .just(.googleLogin)
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case let .appleLogin(token):
            showOnboardingPolicyViewController()
            
        case let .kakaoLogin(token):
            showOnboardingPolicyViewController()
            
        case .googleLogin: break
        case let .signInError(signInType):
            state.signInError = signInType
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
