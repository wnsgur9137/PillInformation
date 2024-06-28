//
//  SceneDelegate.swift
//  MyPageDemoApp
//
//  Created by JunHyeok Lee on 6/28/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit

import MyPage
import BasePresentation

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    let myPageDemoAppDIContainer = MyPageDemoAppDIContainer()
    var myPageCoordinator: MyPageCoordinator?
    
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
        let myPageDIContainer = myPageDemoAppDIContainer.makeMyPageDIContainer()
        myPageCoordinator = DefaultMyPageCoordinator(
            tabBarController: nil,
            navigationController: navigationController,
            dependencies: myPageDIContainer
        )
        myPageCoordinator?.start()
        window?.makeKeyAndVisible()
        return
    }
}
