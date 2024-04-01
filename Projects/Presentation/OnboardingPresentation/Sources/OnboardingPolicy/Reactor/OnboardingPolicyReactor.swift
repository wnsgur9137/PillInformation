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
    
    public init(popViewController: @escaping (Bool) -> Void,
                showMainScene: @escaping () -> Void) {
        self.popViewController = popViewController
        self.showMainScene = showMainScene
    }
}

private struct PolicyChecked {
    var agePolicy: Bool = false
    var appPolicy: Bool = false
    var daytimeNotiPolicy: Bool = false
    var nighttimeNotiPolicy: Bool = false
    
    func isAllChecked() -> Bool {
        return agePolicy && appPolicy && daytimeNotiPolicy && nighttimeNotiPolicy
    }
    
    func isRequiredChecked() -> Bool {
        return agePolicy && appPolicy
    }
}

public final class OnboardingPolicyReactor: Reactor {
    public enum Action {
        case didTapBackwardButton
        case didTapAgePolicy
        case didTapAppPolicy
        case didTapDaytimeNotiPolicy
        case didTapNighttimeNotiPolicy
        case didTapConfirmButton
        case didTapAllAgreeButton
    }
    
    public enum Mutation {
        case dismiss
        case isCheckedAgePolicy
        case isCheckedAppPolicy
        case isCheckedDaytimeNotiPolicy
        case isCheckedNighttimeNotiPolicy
        case confirm
        case allAgree
    }
    
    public struct State {
        var isCheckedAgePolicy: Bool = false
        var isCheckedAppPolicy: Bool = false
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
        case .didTapAgePolicy: return .just(.isCheckedAgePolicy)
        case .didTapAppPolicy: return .just(.isCheckedAppPolicy)
        case .didTapDaytimeNotiPolicy: return .just(.isCheckedDaytimeNotiPolicy)
        case .didTapNighttimeNotiPolicy: return .just(.isCheckedNighttimeNotiPolicy)
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
            
        case .isCheckedAgePolicy:
            policys.agePolicy = !policys.agePolicy
            state.isCheckedAgePolicy = policys.agePolicy
            
        case .isCheckedAppPolicy: 
            policys.appPolicy = !policys.appPolicy
            state.isCheckedAppPolicy = policys.appPolicy
            
        case .isCheckedDaytimeNotiPolicy: 
            policys.daytimeNotiPolicy = !policys.daytimeNotiPolicy
            state.isCheckedDaytimeNotiPolicy = policys.daytimeNotiPolicy
            
        case .isCheckedNighttimeNotiPolicy: 
            policys.nighttimeNotiPolicy = !policys.nighttimeNotiPolicy
            state.isCheckedNighttimeNotiPolicy = policys.nighttimeNotiPolicy
            
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
}
