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

import BasePresentation
import KakaoLibraries

public enum SignInType {
    case saveAppleEmail
    case loadAppleEmail
    case apple
    case kakao
    case signin
}

enum Social: String {
    case apple
    case kakao
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
        case loadedAppleEmail(String)
        case didTapAppleLoginButton(String)
        case didTapKakaoLoginButton
    }
    
    public enum Mutation {
        case saveAppleEmail(String)
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
    
    private func saveAppleEmail(_ email: String) -> Observable<Mutation> {
        return .create() { observable in
            self.userUseCase.saveEmailToKeychain(email)
                .subscribe(onSuccess: { _ in
                    print("Success: saveAppleEmail")
                }, onFailure: { error in
                    observable.onNext(.signInError(.saveAppleEmail))
                })
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
    
    private func loadAppleEmail() -> Single<String> {
        return userUseCase.getEmailToKeychain()
    }
    
    private func loginKakaoTalk() -> Single<String> {
        return KakaoService.isKakaoTalkLoginAvailable() ? KakaoService.loginWithKakaoTalk() : KakaoService.loginWithKakaoAccount()
    }
    
    private func signin(identifier: String, social: String) -> Single<Mutation> {
        return .create { observable in
            self.userUseCase.signin(identifier: identifier, social: social)
                .subscribe(onSuccess: { userModel in
                    observable(.success(userModel.isAgreeRequredPolicies ? .signin : .signup(userModel)))
                }, onFailure: { error in
                    observable(.success(.signInError(.signin)))
                })
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
    
    private func appleSignin(_ token: String) -> Observable<Mutation> {
        return .create { observable in
            self.loadAppleEmail()
                .flatMap { email -> Single<Mutation> in
                    return self.signin(identifier: email, social: Social.apple.rawValue)
                }
                .subscribe(onSuccess: { mutation in
                    observable.onNext(mutation)
                }, onFailure: { error in
                    observable.onNext(.signInError(.loadAppleEmail))
                })
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
    
    private func kakaoSignin() -> Observable<Mutation> {
        return .create { observable in
            self.loginKakaoTalk()
                .flatMap { _ -> Single<Int> in
                    return KakaoService.loadUserID()
                }
                .flatMap { userID -> Single<Mutation> in
                    return self.signin(identifier: "\(userID)", social: Social.kakao.rawValue)
                }
                .subscribe(onSuccess: { mutation in
                    observable.onNext(mutation)
                }, onFailure: { _ in
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
        case let .loadedAppleEmail(email):
            return saveAppleEmail(email)
            
        case let .didTapAppleLoginButton(token):
            return appleSignin(token)
            
        case .didTapKakaoLoginButton:
            return kakaoSignin()
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .saveAppleEmail:
            break
            
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
