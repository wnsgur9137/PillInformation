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
    case signin
}

public struct SignInFlowAction {
    let showOnboardingPolicyViewController: (UserModel) -> Void
    let showMainScene: () -> Void
    
    public init(showOnboardingPolicyViewController: @escaping (UserModel) -> Void,
                showMainScene: @escaping () -> Void) {
        self.showOnboardingPolicyViewController = showOnboardingPolicyViewController
        self.showMainScene = showMainScene
    }
}

public final class SignInReactor: Reactor {
    public enum Action {
        case didTapAppleLoginButton(String)
        case didTapKakaoLoginButton
    }
    
    public enum Mutation {
        case signin
        case signup(UserModel)
        case signInError(SignInType)
    }
    
    public struct State {
        var signInError: SignInType?
    }
    
    public var initialState = State()
    private let disposeBag = DisposeBag()
    private let userUseCase: UserUseCase
    private let flowAction: SignInFlowAction
    
    public init(with useCase: UserUseCase,
                flowAction: SignInFlowAction) {
        self.userUseCase = useCase
        self.flowAction = flowAction
    }
    
    private func loginKakaoTalk() -> Single<String> {
        return KakaoService.isKakaoTalkLoginAvailable() ? KakaoService.loginWithKakaoTalk() : KakaoService.loginWithKakaoAccount()
    }
    
    private func signin(token: String) -> Observable<Mutation> {
        return Observable<Mutation>.create { observable in
            self.userUseCase.signin(token: token)
                .subscribe(onSuccess: { userModel in
                    if userModel.isAgreeRequredPolicies {
                        observable.onNext(.signin)
                    } else {
                        observable.onNext(.signup(userModel))
                    }
                    
                }, onFailure: { error in
                    observable.onNext(.signInError(.signin))
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
            return signin(token: token)
            
        case .didTapKakaoLoginButton:
            return .create { observable in
                self.loginKakaoTalk()
                    .flatMap { _ -> Single<Int> in
                        return KakaoService.loadUserID()
                    }
                    .subscribe(onSuccess: { userID in
                        self.signin(token: "\(userID)")
                            .subscribe(onNext: { mutation in
                                observable.onNext(mutation)
                            })
                            .disposed(by: self.disposeBag)
                        
                    }, onFailure: { _ in
                        observable.onNext(.signInError(.signin))
                    })
                    .disposed(by: self.disposeBag)
                
                return Disposables.create()
            }
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .signin:
            showMainScene()
            
        case let .signup(userModel):
            showOnboardingPolicyViewController(userModel: userModel)
            
        case let .signInError(signInType):
            state.signInError = signInType
        }
        return state
    }
}

// MARK: - Flow Action
extension SignInReactor {
    private func showMainScene() {
        flowAction.showMainScene()
    }
    
    private func showOnboardingPolicyViewController(userModel: UserModel) {
        flowAction.showOnboardingPolicyViewController(userModel)
    }
}
