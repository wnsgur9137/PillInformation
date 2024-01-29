//
//  HomeCoordinator.swift
//  Home
//
//  Created by JunHyeok Lee on 1/30/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit
import Common

public protocol HomeCoordinatorDependencies {
    func makeHomeViewController() -> HomeViewController
}

public protocol HomeCoordinator: Coordinator {
    func showHomeViewController()
}

public final class DefaultHomeCoordinator: HomeCoordinator {
    public weak var finishDelegate: CoordinatorFinishDelegate?
    public weak var navigationController: UINavigationController?
    public var childCoordinators: [Coordinator] = []
    public var type: CoordinatorType { .home }
    
    private let dependencies: HomeCoordinatorDependencies
    private weak var homeViewController: HomeViewController?
    
    public init(navigationController: UINavigationController,
                dependencies: HomeCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    public func start() {
        showHomeViewController()
    }
    
    public func showHomeViewController() {
        let viewController = dependencies.makeHomeViewController()
        navigationController?.pushViewController(viewController, animated: false)
        homeViewController = viewController
    }
}
