//
//  SceneDelegate.swift
//  AlarmDemoApp
//
//  Created by JunHyeok Lee on 4/22/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit

import Alarm
import BasePresentation

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    let alarmDemoAppDIContainer = AlarmDemoAppDIContainer()
    var alarmCoordinator: AlarmCoordinator?
    
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
        let alarmDIContainer = alarmDemoAppDIContainer.makeAlarmDIContainer()
        alarmCoordinator = DefaultAlarmCoordinator(
            navigationController: navigationController,
            dependencies: alarmDIContainer
        )
        alarmCoordinator?.start()
        window?.makeKeyAndVisible()
        return
    }
}
