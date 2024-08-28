//
//  SceneDelegate.swift
//  OnboardingDemoApp
//
//  Created by JunHyeok Lee on 8/28/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit

import Onboarding
import BasePresentation

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    let onboardingDemoAppDIContainer = OnboardingDemoAppDIContainer()
    var onboardingCoordinator: OnboardingCoordinator?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
#if DEBUG
//        Bundle(path: "/Applications/InjectionIII.app/Contents/Resources/iOSInjection.bundle")?.load()
#endif
        
        let navigationController = UINavigationController()
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.view.backgroundColor = Constants.Color.background
        window?.rootViewController = navigationController
        let onboardingDIContainer = onboardingDemoAppDIContainer.makeOnboardingDIContainer()
        onboardingCoordinator = DefaultOnboardingCoordinator(
            navigationController: navigationController,
            dependencies: onboardingDIContainer
        )
        onboardingCoordinator?.start()
        window?.makeKeyAndVisible()
        return
    }
}
