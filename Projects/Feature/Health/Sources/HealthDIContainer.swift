//
//  HealthDIContainer.swift
//  Health
//
//  Created by JunHyeok Lee on 8/6/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation

import NetworkInfra
import BasePresentation
import BaseDomain
import HealthData
import HealthDomain
import HealthPresentation

public final class HealthDIContainer {
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

extension HealthDIContainer: HealthCoordinatorDependencies {
    private func makeHealthReactor(flowAction: HealthFlowAction) -> HealthReactor {
        return HealthReactor(flowAction: flowAction)
    }
    public func makeHealthViewController(flowAction: HealthFlowAction) -> HealthViewController {
        return HealthViewController.create(with: makeHealthReactor(flowAction: flowAction))
    }
}
