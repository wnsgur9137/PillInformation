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

import BasePresentation

public struct OnboardingPolicyFlowAction {
    public let popViewController: (Bool) -> Void
    public let showMainScene: () -> Void
    public let showPolicyViewController: (PolicyReactor.PolicyType) -> Void
    
    public init(popViewController: @escaping (Bool) -> Void,
                showMainScene: @escaping () -> Void,
                showPolicyViewController: @escaping (PolicyReactor.PolicyType) -> Void) {
        self.popViewController = popViewController
        self.showMainScene = showMainScene
        self.showPolicyViewController = showPolicyViewController
    }
}

private struct PolicyChecked {
    var agePolicy: Bool = false
    var appPolicy: Bool = false
    var privacyPolicy: Bool = false
    var daytimeNotiPolicy: Bool = false
    var nighttimeNotiPolicy: Bool = false
    
    func isAllChecked() -> Bool {
        return agePolicy && appPolicy && privacyPolicy && daytimeNotiPolicy && nighttimeNotiPolicy
    }
    
    func isRequiredChecked() -> Bool {
        return agePolicy && appPolicy && privacyPolicy
    }
}

public final class OnboardingPolicyReactor: Reactor {
    public enum Action {
        case didTapBackwardButton
        case didTapAgePolicy
        case didTapAppPolicy
        case didTapPrivacyPolicy
        case didTapDaytimeNotiPolicy
        case didTapNighttimeNotiPolicy
        case didTapAppPolicyMoreButton
        case didTapPrivacyPolicyMoreButton
        case didTapConfirmButton
        case didTapAllAgreeButton
    }
    
    public enum Mutation {
        case dismiss
        case checkAgePolicy
        case checkAppPolicy
        case checkPrivacyPolicy
        case checkDaytimeNotiPolicy
        case checkNighttimeNotiPolicy
        case showPolicyViewController(PolicyReactor.PolicyType)
        case confirm
        case isError
    }
    
    public struct State {
        var isCheckedAgePolicy: Bool = false
        var isCheckedAppPolicy: Bool = false
        var isCheckedPrivacyPolicy: Bool = false
        var isCheckedDaytimeNotiPolicy: Bool = false
        var isCheckedNighttimeNotiPolicy: Bool = false
        var isRequiredChecked: Bool = false
        var isError: Void = Void()
    }
    
    public var initialState = State()
    private let userUseCase: UserUseCase
    public let flowAction: OnboardingPolicyFlowAction
    private let disposeBag = DisposeBag()
    
    private var policies = PolicyChecked()
    private var user: UserModel
    
    public init(user: UserModel,
                userUseCase: UserUseCase,
                flowAction: OnboardingPolicyFlowAction) {
        self.user = user
        self.userUseCase = userUseCase
        self.flowAction = flowAction
    }
    
    private func updateUserPolicies() -> Observable<Mutation> {
        return .create() { observable in
            self.postUserPolicies()
                .subscribe(onSuccess: { userModel in
                    self.updateUserStorage()
                        .subscribe(onNext: { mutation in
                            observable.onNext(mutation)
                        })
                        .disposed(by: self.disposeBag)
                    
                }, onFailure: { error in
                    observable.onNext(.isError)
                })
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
    
    private func postUserPolicies() -> Single<UserModel> {
        user = UserModel(
            id: user.id,
            isAgreeAppPolicy: policies.appPolicy,
            isAgreeAgePolicy: policies.agePolicy,
            isAgreePrivacyPolicy: policies.privacyPolicy,
            isAgreeDaytimeNoti: policies.daytimeNotiPolicy,
            isAgreeNighttimeNoti: policies.nighttimeNotiPolicy,
            accessToken: user.accessToken,
            refreshToken: user.refreshToken, 
            social: user.social
        )
        return userUseCase.post(user)
    }
    
    private func updateUserStorage() -> Observable<Mutation> {
        return .create() { observable in
            self.userUseCase.updateStorage(self.user)
                .subscribe(onSuccess: { user in
                    observable.onNext(.confirm)
                }, onFailure: { error in
                    observable.onNext(.isError)
                })
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
}

// MARK: - React
extension OnboardingPolicyReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapBackwardButton: 
            return .just(.dismiss)
            
        case .didTapAgePolicy: 
            policies.agePolicy = !policies.agePolicy
            return .just(.checkAgePolicy)
            
        case .didTapAppPolicy: 
            policies.appPolicy = !policies.appPolicy
            return .just(.checkAppPolicy)
            
        case .didTapPrivacyPolicy: 
            policies.privacyPolicy = !policies.privacyPolicy
            return .just(.checkPrivacyPolicy)
            
        case .didTapDaytimeNotiPolicy: 
            policies.daytimeNotiPolicy = !policies.daytimeNotiPolicy
            return .just(.checkDaytimeNotiPolicy)
            
        case .didTapNighttimeNotiPolicy: 
            policies.nighttimeNotiPolicy = !policies.nighttimeNotiPolicy
            return .just(.checkNighttimeNotiPolicy)
            
        case .didTapAppPolicyMoreButton: 
            return .just(.showPolicyViewController(.app))
            
        case .didTapPrivacyPolicyMoreButton: 
            return .just(.showPolicyViewController(.privacy))
            
        case .didTapConfirmButton:
            return updateUserPolicies()
            
        case .didTapAllAgreeButton:
            policies.agePolicy = true
            policies.appPolicy = true
            policies.privacyPolicy = true
            policies.daytimeNotiPolicy = true
            policies.nighttimeNotiPolicy = true
            return updateUserPolicies()
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .dismiss: 
            popViewController()
            return state
            
        case .checkAgePolicy:
            state.isCheckedAgePolicy = policies.agePolicy
            
        case .checkAppPolicy:
            state.isCheckedAppPolicy = policies.appPolicy
            
        case .checkPrivacyPolicy:
            state.isCheckedPrivacyPolicy = policies.privacyPolicy
            
        case .checkDaytimeNotiPolicy:
            state.isCheckedDaytimeNotiPolicy = policies.daytimeNotiPolicy
            
        case .checkNighttimeNotiPolicy:
            state.isCheckedNighttimeNotiPolicy = policies.nighttimeNotiPolicy
            
        case let .showPolicyViewController(type):
            showPolicyViewController(type: type)
            
        case .confirm:
            showMainScene()
            
        case .isError:
            state.isError = Void()
        }
        
        state.isRequiredChecked = policies.isRequiredChecked()
        
        return state
    }
}

// MARK: - Flow Action
extension OnboardingPolicyReactor {
    private func popViewController(animated: Bool = true) {
        flowAction.popViewController(animated)
    }
    
    private func showMainScene() {
        flowAction.showMainScene()
    }
    
    private func showPolicyViewController(type: PolicyReactor.PolicyType) {
        flowAction.showPolicyViewController(type)
    }
}
