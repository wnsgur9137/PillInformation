//
//  SceneDelegate.swift
//  MyPageDemoApp
//
//  Created by JunHyeok Lee on 6/28/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit

import Health
import BasePresentation

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    let healthDemoAppDIContainer = HealthDemoAppDIContainer()
    var healthCoordinator: HealthCoordinator?
    
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
        let healthDIContainer = healthDemoAppDIContainer.makeHealthDIContainer()
        healthCoordinator = DefaultHealthCoordinator(
            navigationController: navigationController,
            dependencies: healthDIContainer,
            tabDependencies: nil
        )
        healthCoordinator?.start()
        window?.makeKeyAndVisible()
        return
    }
}
