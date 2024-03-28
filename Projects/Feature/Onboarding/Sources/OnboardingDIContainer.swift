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
        
        public init(networkManager: NetworkManager) {
            self.networkManager = networkManager
        }
    }
    
    let dependencies: Dependencies
    
    public init(dependenceis: Dependencies) {
        self.dependencies = dependenceis
    }
}

// MARK: - OnboardingCoordinator Dependencies
extension OnboardingDIContainer: OnboardingCoordinatorDependencies {
    public func showMainScene() {
        
    }
    
    public func makeSignInReactor() -> SignInReactor {
        return SignInReactor()
    }
    
    public func makeSignInViewController() -> SignInViewController {
        return SignInViewController.create(with: makeSignInReactor())
    }
}
