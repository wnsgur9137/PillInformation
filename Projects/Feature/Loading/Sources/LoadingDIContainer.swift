//
//  LoadingDIContainer.swift
//  Loading
//
//  Created by JunHyeok Lee on 4/12/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit

import NetworkInfra
import LoadingData
import LoadingDomain
import LoadingPresentation

public final class LoadingDIContainer {
    public struct Dependencies {
        let networkManager: NetworkManager
        
        public init(networkManager: NetworkManager) {
            self.networkManager = networkManager
        }
    }
    
    let dependencies: Dependencies
    
    public init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
}

// MARK: - LoadingCoordinator Dependencies
extension LoadingDIContainer: LoadingCoordinatorDependencies {
    public func makeLoadingReactor(flowAction: LoadingFlowAction) -> LoadingReactor {
        return LoadingReactor(flowAction: flowAction)
    }
    
    public func makeLoadingViewController(flowAction: LoadingFlowAction) -> LoadingViewController {
        return LoadingViewController.create(with: makeLoadingReactor(flowAction: flowAction))
    }
}
