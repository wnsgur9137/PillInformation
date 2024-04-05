//
//  OnboardingSceneDIContainer.swift
//  PillInformation
//
//  Created by JunHyeok Lee on 3/28/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit

import Features
import NetworkInfra
import Onboarding

final class OnboardingSceneDIContainer {
    struct Dependencies {
        let networkManager: NetworkManager
        let googleClientID: String
    }
    
    let dependencies: Dependencies
    
    private let onboardingDIContainer: OnboardingDIContainer
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
        self.onboardingDIContainer = OnboardingDIContainer(dependenceis: .init(
            networkManager: dependencies.networkManager,
            googleClientID: dependencies.googleClientID
        ))
    }
    
    func makeOnboardingViewController(navigationController: UINavigationController) -> OnboardingCoordinator {
        return DefaultOnboardingCoordinator(
            navigationController: navigationController,
            dependencies: onboardingDIContainer
        )
    }
}
