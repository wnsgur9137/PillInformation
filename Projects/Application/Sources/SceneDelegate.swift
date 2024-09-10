//
//  SceneDelegate.swift
//  PillInformation
//
//  Created by JunHyeok Lee on 3/19/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit

import InjectionManager
import KakaoLibraries
import NotificationInfra

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    let appDIContainer = AppDIContainer()
    var appFlowCoordinator: AppFlowCoordinator?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
#if DEBUG
//        Bundle(path: "/Applications/InjectionIII.app/Contents/Resources/iOSInjection.bundle")?.load()
#endif
        
        let tabBarController = MainTabBarController.create()
        window?.rootViewController = tabBarController
        appFlowCoordinator = AppFlowCoordinator(
            tabBarController: tabBarController,
            appDIContainer: appDIContainer
        )
        
        appFlowCoordinator?.startSplashView(navigationController: UINavigationController())
        
//        appFlowCoordinator?.startOnboarding(navigationController: UINavigationController())
        
//        appFlowCoordinator?.start()
        window?.makeKeyAndVisible()
        return
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        NotificationService.deleteAllDeliveredNotifications()
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url,
           KakaoService.isKakaoTalkLoginUrl(url) {
            _ = KakaoService.handleOpenURL(url)
        }
    }
}
