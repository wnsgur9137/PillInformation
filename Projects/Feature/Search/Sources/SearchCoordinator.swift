//
//  SearchCoordinator.swift
//  Search
//
//  Created by JunHyeok Lee on 1/30/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit

import SearchPresentation
import BasePresentation

public protocol SearchCoordinatorDependencies {
    func makeSearchViewController(flowAction: SearchFlowAction) -> SearchViewController
}

public protocol SearchCoordinator: Coordinator {
    func showSearchViewController()
}

public final class DefaultSearchCoordinator: SearchCoordinator {
    public weak var finishDelegate: CoordinatorFinishDelegate?
    public weak var navigationController: UINavigationController?
    public var childCoordinators: [Coordinator] = []
    public var type: CoordinatorType { .search }
    
    private let dependencies: SearchCoordinatorDependencies
    private weak var searchViewController: SearchViewController?
    
    public init(navigationController: UINavigationController,
                dependencies: SearchCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    public func start() {
        showSearchViewController()
    }
    
    public func showSearchViewController() {
        let flowAction = SearchFlowAction()
        let viewController = dependencies.makeSearchViewController(flowAction: flowAction)
        navigationController?.pushViewController(viewController, animated: false)
        searchViewController = viewController
    }
}
