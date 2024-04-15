//
//  AppFlowCoordinator.swift
//  Application
//
//  Created by JunHyeok Lee on 1/30/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit

import Features

final class AppFlowCoordinator {
    
    var tabBarController: UITabBarController
    private let appDIContainer: AppDIContainer
    
    init(tabBarController: UITabBarController,
         appDIContainer: AppDIContainer) {
        self.tabBarController = tabBarController
        self.appDIContainer = appDIContainer
    }
    
    func start() {
        tabBarController.tabBar.isHidden = false
        let mainSceneDIContainer = appDIContainer.makeMainSceneDIContainer()
        let flow = mainSceneDIContainer.makeTabBarCoordinator(tabBarController: tabBarController)
        flow.start()
    }
    
    func startOnboarding(navigationController: UINavigationController) {
        tabBarController.tabBar.isHidden = true
        tabBarController.viewControllers = [navigationController]
        let onboardingSceneDIContainer = appDIContainer.makeOnboardingSceneDIContainer()
        let flow = onboardingSceneDIContainer.makeOnboardingViewController(navigationController: navigationController)
        flow.start()
    }
    
    func startLoadingView(navigationController: UINavigationController) {
        tabBarController.tabBar.isHidden = true
        tabBarController.viewControllers = [navigationController]
        let loadingSceneDIContainer = appDIContainer.makeLoadingSceneDIContainer()
        let flow = loadingSceneDIContainer.makeLoadingViewController(navigationController: navigationController)
        flow.start()
    }
}
