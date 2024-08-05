//
//  SceneDelegate.swift
//  BookmarkDemoApp
//
//  Created by JunHyeok Lee on 8/2/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit

import Bookmark
import BasePresentation

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    let bookmarkDemoAppDIContainer = BookmarkDemoAppDIContainer()
    var bookmarkCoordinator: BookmarkCoordinator?
    
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
        let bookmarkDIContainer = bookmarkDemoAppDIContainer.makeBookmarkDIContainer()
        bookmarkCoordinator = DefaultBookmarkCoordinator(
            navigationController: navigationController,
            dependencies: bookmarkDIContainer,
            tabDependencies: nil
        )
        bookmarkCoordinator?.start()
        window?.makeKeyAndVisible()
        return
    }
}
