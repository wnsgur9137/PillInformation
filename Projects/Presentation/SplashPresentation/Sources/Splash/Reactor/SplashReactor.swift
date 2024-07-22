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
import DeviceCheck

public struct SplashFlowAction {
    let showMainScene: () -> Void
    let showOnboardingSceneSigninViewController: () -> Void
    let showOnboardingScene: () -> Void

    public init(showMainScene: @escaping () -> Void,
                showOnboardingSceneSigninViewController: @escaping () -> Void,
                showOnboardingScene: @escaping () -> Void) {
        self.showMainScene = showMainScene
        self.showOnboardingSceneSigninViewController = showOnboardingSceneSigninViewController
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
        case checkOnboarding
    }
    
    public struct State {
        
    }
    
    public var initialState = State()
    private let disposeBag = DisposeBag()
    private let splashUseCase: SplashUseCase
    private let flowAction: SplashFlowAction
    private var isShowAlarmTab: Bool = false
    
    public init(with useCase: SplashUseCase,
                flowAction: SplashFlowAction) {
        self.splashUseCase = useCase
        self.flowAction = flowAction
    }
    
    private func deviceCheck() -> Single<DeviceCheckResultModel?> {
        let device = DCDevice.current
        guard device.isSupported else { return .just(nil) }
        return .create { [weak self] single in
            guard let self = self else { return Disposables.create() }
            Task {
                do {
                    let deviceToken = try await device.generateToken()
                    let deviceTokenString = deviceToken.base64EncodedString()
                    self.splashUseCase.deviceCheck(deviceTokenString)
                        .subscribe(onSuccess: { result in
                            single(.success(result))
                        }, onFailure: { error in
                            single(.failure(error))
                        })
                        .disposed(by: self.disposeBag)
                }
            }
            return Disposables.create()
        }
    }
    
    private func isShownOnboarding(completion: @escaping (Bool) -> Void) {
        splashUseCase.isShownOnboarding()
            .subscribe(onSuccess: { isShown in
                completion(isShown)
            }, onFailure: { error in
                completion(false)
            })
            .disposed(by: disposeBag)
    }
    
    private func updateIsShownOnboarding(_ isShown: Bool) -> Single<Bool> {
        splashUseCase.updateIsShownOnboarding(isShown)
    }
    
    private func checkNeedSignin() -> Observable<Mutation> {
        return .create { [weak self] observable in
            guard let self = self else { return Disposables.create() }
            self.splashUseCase.executeIsNeedSignIn()
                .flatMap { isNeedSignIn -> Single<(Bool, Bool)> in
                    return self.splashUseCase.executeIsShowAlarmTab().map { (isNeedSignIn, $0) }
                }
                .subscribe(onSuccess: { [weak self] isNeedSignIn, isShowAlarmTab in
                    guard let self = self else { return }
                    self.isShowAlarmTab = isShowAlarmTab
                    if isNeedSignIn {
                        self.checkSignin()
                            .bind(to: observable)
                            .disposed(by: self.disposeBag)
                    } else {
                        observable.onNext(.checkOnboarding)
                    }
                }, onFailure: { error in
                    observable.onNext(.checkOnboarding)
                })
                .disposed(by: self.disposeBag)
            return Disposables.create()
        }
    }
    
    private func checkSignin() -> Observable<Mutation> {
        return .create() { observable in
            self.splashUseCase.fetchUserStorage()
                .flatMap { userModel -> Single<UserModel> in
                    return self.splashUseCase.signin(accessToken: userModel.accessToken)
                }
                .subscribe(onSuccess: { userModel in
                    observable.onNext(.isSignin)
                }, onFailure: { error in
                    self.splashUseCase.deleteUserStorage()
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
            return checkNeedSignin()
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        let state = state
        switch mutation {
        case .isSignin:
            showMainScene()
            
        case .isNotSignin:
            showOnboardingSceneLoginViewController()
            
        case .checkOnboarding:
            isShownOnboarding { isShown in
                isShown ? self.showMainScene() : self.showOnboardingScene()
            }
        }
        return state
    }
}
// MARK: - Flow Action
extension SplashReactor {
    private func showMainScene() {
        flowAction.showMainScene()
    }
    
    private func showOnboardingSceneLoginViewController() {
        updateIsShownOnboarding(true)
            .subscribe()
            .disposed(by: disposeBag)
        flowAction.showOnboardingSceneSigninViewController()
    }
    
    private func showOnboardingScene() {
        updateIsShownOnboarding(true)
            .subscribe()
            .disposed(by: disposeBag)
        flowAction.showOnboardingScene()
    }
}
