//
//  OnboardingDIContainer.swift
//  Onboarding
//
//  Created by JunHyeok Lee on 3/28/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit

import NetworkInfra
import OnboardingData
import OnboardingDomain
import OnboardingPresentation

public final class OnboardingDIContainer {
    public struct Dependencies {
        let networkManager: NetworkManager
        let kakaoNativeAppKey: String
        
        public init(networkManager: NetworkManager,
                    kakaoNativeAppKey: String) {
            self.networkManager = networkManager
            self.kakaoNativeAppKey = kakaoNativeAppKey
        }
    }
    
    let dependencies: Dependencies
    
    public init(dependenceis: Dependencies) {
        self.dependencies = dependenceis
    }
}

// MARK: - OnboardingCoordinator Dependencies
extension OnboardingDIContainer: OnboardingCoordinatorDependencies {
    
    // MARK: - SignIn
    public func makeSignInReactor(flowAction: SignInFlowAction) -> SignInReactor {
        return SignInReactor(flowAction: flowAction)
    }
    
    public func makeSignInViewController(flowAction: SignInFlowAction) -> SignInViewController {
        return SignInViewController.create(with:
                                            makeSignInReactor(flowAction: flowAction),
                                           kakaoNativeAppKey: dependencies.kakaoNativeAppKey)
    }
    
    // MARK: - OnboardingPolicy
    public func makeUserRepository() -> UserRepository {
        return DefaultUserRepository()
    }
    
    public func makeUserUseCase() -> UserUseCase {
        return DefaultUserUseCase(with: makeUserRepository())
    }
    
    public func makeOnboardingPolicyReactor(flowAction: OnboardingPolicyFlowAction) -> OnboardingPolicyReactor {
        return OnboardingPolicyReactor(userUseCase: makeUserUseCase(),
                                       flowAction: flowAction)
    }
    
    public func makeOnboardingPolicyViewController(flowAction: OnboardingPolicyFlowAction) -> OnboardingPolicyViewController {
        return OnboardingPolicyViewController.create(with: makeOnboardingPolicyReactor(flowAction: flowAction))
    }
}
