//
//  SplashSceneDIContainer.swift
//  PillInformation
//
//  Created by JunHyeok Lee on 4/12/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit

import Features
import NetworkInfra
import Splash

final class SplashSceneDIContainer {
    struct Dependencies {
        let networkManager: NetworkManager
    }
    
    let dependencies: Dependencies
    
    private let splashDIContainer: SplashDIContainer
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
        self.splashDIContainer = SplashDIContainer(dependencies: .init(networkManager: dependencies.networkManager))
    }
    
    func makeSplashCoordinator(navigationController: UINavigationController) -> SplashCoordinator
    {
        return DefaultSplashCoordinator(
            navigationController: navigationController,
            dependencies: splashDIContainer
        )
    }
}
