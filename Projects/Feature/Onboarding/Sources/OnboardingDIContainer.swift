//
//  OnboardingDIContainer.swift
//  Onboarding
//
//  Created by JunHyeok Lee on 3/28/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit

import NetworkInfra
import BaseData
import BasePresentation
import OnboardingData
import OnboardingDomain
import OnboardingPresentation

public final class OnboardingDIContainer {
    public struct Dependencies {
        let networkManager: NetworkManager
        let isShowAlarmPrivacy: Bool
        
        public init(networkManager: NetworkManager,
                    isShowAlarmPrivacy: Bool) {
            self.networkManager = networkManager
            self.isShowAlarmPrivacy = isShowAlarmPrivacy
        }
    }
    
    let dependencies: Dependencies
    
    public init(dependenceis: Dependencies) {
        self.dependencies = dependenceis
    }
}

// MARK: - OnboardingCoordinator Dependencies
extension OnboardingDIContainer: OnboardingCoordinatorDependencies {
    
    private func makeUserRepository() -> UserRepository {
        return DefaultUserRepository(networkManager: dependencies.networkManager)
    }
    private func makeUserOnboardingRepository() -> UserOnboardingRepository {
        return DefaultUserOnboardingRepository(userRepository: makeUserRepository())
    }
    public func makeUserUseCase() -> UserUseCase {
        return DefaultUserUseCase(with: makeUserOnboardingRepository())
    }
    
    // MARK: - SignIn
    private func makeSignInReactor(flowAction: SignInFlowAction) -> SignInReactor {
        return SignInReactor(
            with: makeUserUseCase(),
            flowAction: flowAction
        )
    }
    public func makeSignInViewController(flowAction: SignInFlowAction) -> SignInViewController {
        return SignInViewController.create(with: makeSignInReactor(flowAction: flowAction))
    }
    
    // MARK: - Intro
    private func makeIntroReactor(flowAction: IntroFlowAction) -> IntroReactor {
        return IntroReactor(flowAction: flowAction)
    }
    public func makeIntroViewController(flowAction: IntroFlowAction) -> IntroViewController {
        return IntroViewController.create(with: makeIntroReactor(flowAction: flowAction))
    }
    
    // MARK: - OnboardingPolicy(User)
    private func makeOnboardingPolicyReactor(user: UserModel?,
                                            flowAction: OnboardingPolicyFlowAction) -> OnboardingPolicyReactor {
        return OnboardingPolicyReactor(
            user: user,
            isShowAlarmPrivacy: dependencies.isShowAlarmPrivacy,
            userUseCase: makeUserUseCase(),
            flowAction: flowAction
        )
    }
    public func makeOnboardingPolicyViewController(user: UserModel?,
                                                   flowAction: OnboardingPolicyFlowAction) -> OnboardingPolicyViewController {
        return OnboardingPolicyViewController.create(with: makeOnboardingPolicyReactor(
            user: user,
            flowAction: flowAction
        ))
    }

    // MARK: - Onboard
    private func makeOnboardReactor(flowAction: OnboardFlowAction) -> OnboardReactor {
        return OnboardReactor(
            with: makeUserUseCase(),
            flowAction: flowAction
        )
    }
    public func makeOnboardViewController(flowAction: OnboardFlowAction) -> OnboardViewController {
        return OnboardViewController.create(with: makeOnboardReactor(flowAction: flowAction))
    }
}
