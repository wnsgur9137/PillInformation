//
//  HealthCoordinator.swift
//  Health
//
//  Created by JunHyeok Lee on 8/6/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit

import BasePresentation
import HealthPresentation

public protocol HealthCoordinatorDependencies {
    
}

public protocol HealthTabDependencies {
    
}

public protocol HealthCoordinator: Coordinator {
    
}

public final class DefaultHealthCoordinator: HealthCoordinator {
    public weak var finishDelegate: CoordinatorFinishDelegate?
    public weak var navigationController: UINavigationController?
    public var childCoordinators: [Coordinator] = []
    public var type: CoordinatorType { .health }
    
    private let dependencies: HealthCoordinatorDependencies
    private let tabDependencies: HealthTabDependencies?
    
    public init(navigationController: UINavigationController,
                dependencies: HealthCoordinatorDependencies,
                tabDependencies: HealthTabDependencies?) {
        self.navigationController = navigationController
        self.dependencies = dependencies
        self.tabDependencies = tabDependencies
    }
    
    public func start() {
        showHealthViewController()
    }
    
    public func showHealthViewController() {
        
    }
}
