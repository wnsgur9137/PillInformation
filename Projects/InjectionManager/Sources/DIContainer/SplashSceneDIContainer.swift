//
//  SplashSceneDIContainer.swift
//  InjectionManager
//
//  Created by JunHyoek Lee on 8/21/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit

import Features
import NetworkInfra
import Splash
import BasePresentation

public final class SplashSceneDIContainer {
    struct Dependencies {
        let networkManager: NetworkManager
    }
    
    let dependencies: Dependencies
    private let appFlowDependencies: AppFlowDependencies
    
    private let splashDIContainer: SplashDIContainer
    
    init(dependencies: Dependencies,
         appFlowDependencies: AppFlowDependencies) {
        self.dependencies = dependencies
        self.appFlowDependencies = appFlowDependencies
        self.splashDIContainer = SplashDIContainer(dependencies: .init(networkManager: dependencies.networkManager))
    }
    
    public func makeSplashCoordinator(navigationController: UINavigationController) -> SplashCoordinator
    {
        return DefaultSplashCoordinator(
            navigationController: navigationController,
            dependencies: splashDIContainer,
            appFlowDependencies: appFlowDependencies
        )
    }
}
