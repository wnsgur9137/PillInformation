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
    func makeHealthViewController(flowAction: HealthFlowAction) -> HealthViewController
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
    
    private weak var healthViewController: HealthViewController?
    
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
        let flowAction = HealthFlowAction()
        let viewController = dependencies.makeHealthViewController(flowAction: flowAction)
        navigationController?.pushViewController(viewController, animated: false)
        healthViewController = viewController
    }
}
