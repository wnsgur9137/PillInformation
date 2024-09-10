//
//  OnboardingSceneDIContainer.swift
//  InjectionManager
//
//  Created by JunHyoek Lee on 8/21/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit

import Features
import NetworkInfra
import Onboarding
import BasePresentation

public final class OnboardingSceneDIContainer {
    struct Dependencies {
        let networkManager: NetworkManager
        let isShowAlarmPrivacy: Bool
    }
    
    let dependencies: Dependencies
    private let appFlowDependencies: AppFlowDependencies
    
    private let onboardingDIContainer: OnboardingDIContainer
    
    init(dependencies: Dependencies,
         appFlowDependencies: AppFlowDependencies) {
        self.dependencies = dependencies
        self.appFlowDependencies = appFlowDependencies
        self.onboardingDIContainer = OnboardingDIContainer(dependenceis: .init(
            networkManager: dependencies.networkManager,
            isShowAlarmPrivacy: dependencies.isShowAlarmPrivacy
        ))
    }
    
    public func makeOnboardingCoordinator(navigationController: UINavigationController) -> OnboardingCoordinator {
        return DefaultOnboardingCoordinator(
            navigationController: navigationController,
            dependencies: onboardingDIContainer,
            appFlowDependencies: appFlowDependencies
        )
    }
}
