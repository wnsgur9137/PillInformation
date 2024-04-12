//
//  LoadingSceneDIContainer.swift
//  PillInformation
//
//  Created by JunHyeok Lee on 4/12/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit

import Features
import NetworkInfra
import Loading

final class LoadingSceneDIContainer {
    struct Dependencies {
        let networkManager: NetworkManager
    }
    
    let dependencies: Dependencies
    
    private let loadingDIContainer: LoadingDIContainer
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
        self.loadingDIContainer = LoadingDIContainer(dependencies: .init(networkManager: dependencies.networkManager))
    }
    
    func makeLoadingViewController(navigationController: UINavigationController) -> LoadingCoordinator
    {
        return DefaultLoadingCoordinator(
            navigationController: navigationController,
            dependencies: loadingDIContainer
        )
    }
}
