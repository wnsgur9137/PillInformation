//
//  SplashCoordinator.swift
//  Splash
//
//  Created by JunHyeok Lee on 4/12/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit

import SplashPresentation
import BasePresentation

public protocol SplashCoordinatorDependencies {
    func makeSplashViewController(flowAction: SplashFlowAction) -> SplashViewController
}

public protocol SplashCoordinator: Coordinator {
    func showSplashViewController()
}

public final class DefaultSplashCoordinator: SplashCoordinator {
    public weak var finishDelegate: CoordinatorFinishDelegate?
    public weak var navigationController: UINavigationController?
    public var childCoordinators: [Coordinator] = []
    public var type: CoordinatorType { .splash }
    
    private let dependencies: SplashCoordinatorDependencies
    private let appFlowDependencies: AppFlowDependencies
    private weak var splashViewController: SplashViewController?
    
    public init(navigationController: UINavigationController,
                dependencies: SplashCoordinatorDependencies,
                appFlowDependencies: AppFlowDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
        self.appFlowDependencies = appFlowDependencies
        navigationController.view.backgroundColor = Constants.Color.background
        navigationController.navigationBar.isHidden = true
    }
    
    public func start() {
        showSplashViewController()
    }
    
    public func showSplashViewController() {
        let flowAction = SplashFlowAction(
            showMainScene: showMainScene,
            showOnboardingScene: showOnboardingScene
        )
        let viewController = dependencies.makeSplashViewController(flowAction: flowAction)
        navigationController?.pushViewController(viewController, animated: false)
        self.splashViewController = viewController
    }
    
    public func popViewController(animated: Bool = true) {
        navigationController?.popViewController(animated: animated)
    }
    
    public func showMainScene() {
        appFlowDependencies.showMain()
    }
    
    public func showOnboardingScene(withSignin: Bool) {
        appFlowDependencies.showOnboarding(isNeedSignin: withSignin)
    }
}
