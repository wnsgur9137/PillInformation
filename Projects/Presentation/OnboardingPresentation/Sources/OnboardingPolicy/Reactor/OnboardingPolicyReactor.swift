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
        case allAgree
    }
    
    public struct State {
        var isCheckedAgePolicy: Bool = false
        var isCheckedAppPolicy: Bool = false
        var isCheckedPrivacyPolicy: Bool = false
        var isCheckedDaytimeNotiPolicy: Bool = false
        var isCheckedNighttimeNotiPolicy: Bool = false
        var isRequiredChecked: Bool = false
    }
    
    public var initialState = State()
    public let flowAction: OnboardingPolicyFlowAction
    private let disposeBag = DisposeBag()
    
    private var policys = PolicyChecked()
    
    public init(flowAction: OnboardingPolicyFlowAction) {
        self.flowAction = flowAction
    }
    
}

// MARK: - React
extension OnboardingPolicyReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapBackwardButton: return .just(.dismiss)
        case .didTapAgePolicy: return .just(.checkAgePolicy)
        case .didTapAppPolicy: return .just(.checkAppPolicy)
        case .didTapPrivacyPolicy: return .just(.checkPrivacyPolicy)
        case .didTapDaytimeNotiPolicy: return .just(.checkDaytimeNotiPolicy)
        case .didTapNighttimeNotiPolicy: return .just(.checkNighttimeNotiPolicy)
        case .didTapAppPolicyMoreButton: return .just(.showPolicyViewController(.app))
        case .didTapPrivacyPolicyMoreButton: return .just(.showPolicyViewController(.privacy))
        case .didTapConfirmButton: return .just(.confirm)
        case .didTapAllAgreeButton: return .just(.allAgree)
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .dismiss: 
            popViewController()
            return state
            
        case .checkAgePolicy:
            policys.agePolicy = !policys.agePolicy
            state.isCheckedAgePolicy = policys.agePolicy
            
        case .checkAppPolicy: 
            policys.appPolicy = !policys.appPolicy
            state.isCheckedAppPolicy = policys.appPolicy
            
        case .checkPrivacyPolicy:
            policys.privacyPolicy = !policys.privacyPolicy
            state.isCheckedPrivacyPolicy = policys.privacyPolicy
            
        case .checkDaytimeNotiPolicy: 
            policys.daytimeNotiPolicy = !policys.daytimeNotiPolicy
            state.isCheckedDaytimeNotiPolicy = policys.daytimeNotiPolicy
            
        case .checkNighttimeNotiPolicy: 
            policys.nighttimeNotiPolicy = !policys.nighttimeNotiPolicy
            state.isCheckedNighttimeNotiPolicy = policys.nighttimeNotiPolicy
            
        case let .showPolicyViewController(type):
            showPolicyViewController(type: type)
            
        case .confirm:
            fallthrough
            
        case .allAgree:
            showMainScene()
        }
        
        state.isRequiredChecked = policys.isRequiredChecked()
        
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
