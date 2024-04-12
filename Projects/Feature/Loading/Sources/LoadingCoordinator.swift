//
//  LoadingCoordinator.swift
//  Loading
//
//  Created by JunHyeok Lee on 4/12/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit

import LoadingPresentation
import BasePresentation

public protocol LoadingCoordinatorDependencies {
    
}

public protocol LoadingCoordinator: Coordinator {
    func showLoadingViewController()
}

public final class DefaultLoadingCoordinator: LoadingCoordinator {
    public weak var finishDelegate: CoordinatorFinishDelegate?
    public weak var navigationController: UINavigationController?
    public var childCoordinators: [Coordinator] = []
    public var type: CoordinatorType { .loading }
    
    private let dependencies: LoadingCoordinatorDependencies
    private weak var loadingViewController: LoadingViewController?
    
    public init(navigationController: UINavigationController,
                dependencies: LoadingCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
        navigationController.view.backgroundColor = Constants.Color.background
        navigationController.navigationBar.isHidden = true
    }
    
    public func start() {
        showLoadingViewController()
    }
    
    public func showLoadingViewController() {
        
    }
    
    public func popViewController(animated: Bool = true) {
        navigationController?.popViewController(animated: animated)
    }
    
    public func showMainScene() {
        NotificationCenter.default.post(name: Notification.Name("showMainScene"), object: nil)
    }
    
    public func showOnboardingScene() {
        NotificationCenter.default.post(name: Notification.Name("showOnboardingScene"), object: nil)
    }
}
