//
//  AppFlowCoordinator.swift
//  Application
//
//  Created by JunHyeok Lee on 1/30/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit

import InjectionManager
import Features
import BasePresentation

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
        let mainSceneDIContainer = appDIContainer.makeMainSceneDIContainer(appFlowDependencies: self)
        let flow = mainSceneDIContainer.makeTabBarCoordinator(tabBarController: tabBarController, isShowAlarmTab: appDIContainer.appConfiguration.isShowAlarmTab)
        flow.start()
    }
    
    func startOnboarding(isNeedSignin: Bool,
                         navigationController: UINavigationController) {
        tabBarController.tabBar.isHidden = true
        tabBarController.viewControllers = [navigationController]
        let onboardingSceneDIContainer = appDIContainer.makeOnboardingSceneDIContainer(appFlowDependencies: self)
        let flow = onboardingSceneDIContainer.makeOnboardingCoordinator(navigationController: navigationController)
        isNeedSignin ? flow.start() : flow.startNonSignin()
    }
    
    func startSplashView(navigationController: UINavigationController) {
        tabBarController.tabBar.isHidden = true
        tabBarController.viewControllers = [navigationController]
        let splashSceneDIContainer = appDIContainer.makeSplashSceneDIContainer(appFlowDependencies: self)
        let flow = splashSceneDIContainer.makeSplashCoordinator(navigationController: navigationController)
        flow.start()
    }
}

extension AppFlowCoordinator: AppFlowDependencies {
    func showMain() {
        start()
    }
    
    func showOnboarding(isNeedSignin: Bool) {
        startOnboarding(isNeedSignin: isNeedSignin,
                        navigationController: UINavigationController())
    }
    
    func showSplash() {
        startSplashView(navigationController: UINavigationController())
    }
}
