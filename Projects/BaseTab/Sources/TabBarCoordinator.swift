//
//  TabBarCoordinator.swift
//  BaseTab
//
//  Created by JunHyeok Lee on 3/20/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit

import Home

public protocol TabBarCoordinator {
    var tabBarController: UITabBarController? { get set }
}

public final class DefaultTabBarCoordinator: TabBarCoordinator {
    public weak var navigationController: UINavigationController?
    public weak var tabBarController: UITabBarController?
    
//    private let homeDependencies: HomeCoordinatorDependencies
    
    public init(tabBarController: UITabBarController) {
        self.tabBarController = tabBarController
    }
    
    public func start() {
        let navigationController = UINavigationController()
        let homeDIContainer = HomeDIContainer()
        navigationController.viewControllers = [homeDIContainer.makeHomeViewController()]
        tabBarController?.setViewControllers([navigationController], animated: true)
        
    }
}
