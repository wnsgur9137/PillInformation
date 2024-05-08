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
    func makeSearchResultViewController(keyword: String, flowAction: SearchResultFlowAction) -> SearchResultViewController
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
    private weak var searchResultViewController: SearchResultViewController?
    
    public init(navigationController: UINavigationController,
                dependencies: SearchCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    public func start() {
        showSearchViewController()
    }
    
    public func showSearchViewController() {
        let flowAction = SearchFlowAction(
            showSearchResultViewController: showSearchResultViewController
        )
        let viewController = dependencies.makeSearchViewController(flowAction: flowAction)
        navigationController?.pushViewController(viewController, animated: false)
        searchViewController = viewController
    }
    
    private func showSearchResultViewController(keyword: String) {
        let flowAction = SearchResultFlowAction()
        let viewController = dependencies.makeSearchResultViewController(keyword: keyword, flowAction: flowAction)
        navigationController?.pushViewController(viewController, animated: true)
        searchResultViewController = viewController
    }
}
