//
//  SceneDelegate.swift
//  HomeDemoApp
//
//  Created by JunHyeok Lee on 8/28/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit

import Home
import BasePresentation

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    let homeDemoAppDIContainer = HomeDemoAppDIContainer()
    var homeCoordinator: HomeCoordinator?
    
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
        let homeDIContainer = homeDemoAppDIContainer.makeHomeDIContainer()
        homeCoordinator = DefaultHomeCoordinator(
            navigationController: navigationController,
            dependencies: homeDIContainer,
            tabDependencies: self
        )
        homeCoordinator?.start()
        window?.makeKeyAndVisible()
        return
    }
}

extension SceneDelegate: HomeTabDependencies {
    func changeTab(index: Int) { }
    func showSearchTab() { }
    func showShapeSearchViewController() { }
    func showMyPageViewController() { }
}
