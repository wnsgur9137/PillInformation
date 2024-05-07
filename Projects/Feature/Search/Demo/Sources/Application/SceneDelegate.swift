//
//  SceneDelegate.swift
//  SearchDemoApp
//
//  Created by JunHyeok Lee on 5/7/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit

import Search
import BasePresentation

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    let searchDemoAppDIContainer = SearchDemoAppDIContainer()
    var searchCoordinator: SearchCoordinator?
    
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
        let searchDIContainer = searchDemoAppDIContainer.makeSearchDIContainer()
        searchCoordinator = DefaultSearchCoordinator(
            navigationController: navigationController,
            dependencies: searchDIContainer
        )
        searchCoordinator?.start()
        window?.makeKeyAndVisible()
        return
    }
}
