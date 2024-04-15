//
//  SplashReactor.swift
//  SplashPresentation
//
//  Created by JunHyeok Lee on 4/12/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import ReactorKit
import RxSwift
import RxCocoa

public struct SplashFlowAction {
    let showMainScene: () -> Void
    let showOnboardingScene: () -> Void

    public init(showMainScene: @escaping () -> Void, showOnboardingScene: @escaping () -> Void) {
        self.showMainScene = showMainScene
        self.showOnboardingScene = showOnboardingScene
    }
}

public final class SplashReactor: Reactor {
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
    private let userUseCase: UserUseCase
    private let flowAction: SplashFlowAction
    
    public init(with useCase: UserUseCase,
                flowAction: SplashFlowAction) {
        self.userUseCase = useCase
        self.flowAction = flowAction
    }
    
    private func checkSignin() -> Observable<Mutation> {
        return .create() { observable in
            
            self.userUseCase.fetchUserStorage()
                .flatMap { userModel -> Single<UserModel> in
                    return self.userUseCase.signin(accessToken: userModel.accessToken)
                }
                .subscribe(onSuccess: { userModel in
                    observable.onNext(.isSignin)
                }, onFailure: { error in
                    self.userUseCase.deleteUserStorage()
                        .subscribe { _ in
                            observable.onNext(.isNotSignin)
                        }
                        .disposed(by: self.disposeBag)
                })
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
}

// MARK: - React
extension SplashReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return checkSignin()
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
extension SplashReactor {
    private func showMainScene() {
        flowAction.showMainScene()
    }
    
    private func showOnboardingScene() {
        flowAction.showOnboardingScene()
    }
}
