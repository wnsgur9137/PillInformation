//
//  MyPageCoordinator.swift
//  MyPage
//
//  Created by JunHyeok Lee on 1/30/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit

import MyPagePresentation
import BasePresentation

public protocol MyPageCoordinatorDependencies {
    func makeMyPageViewController(flowAction: MyPageFlowAction) -> MyPageViewController
}

public protocol MyPageCoordinator: Coordinator {
    func showMyPageViewController()
}

public final class DefaultMyPageCoordinator: MyPageCoordinator {
    public weak var finishDelegate: CoordinatorFinishDelegate?
    public weak var tabBarController: UITabBarController?
    public weak var navigationController: UINavigationController?
    public var childCoordinators: [Coordinator] = []
    public var type: CoordinatorType { .myPage }
    
    private let dependencies: MyPageCoordinatorDependencies
    private weak var myPageViewController: MyPageViewController?
    
    public init(tabBarController: UITabBarController,
                navigationController: UINavigationController,
                dependencies: MyPageCoordinatorDependencies) {
        self.tabBarController = tabBarController
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    public func start() {
        showMyPageViewController()
    }
    
    public func showMyPageViewController() {
        let flowAction = MyPageFlowAction()
        let viewController = dependencies.makeMyPageViewController(flowAction: flowAction)
        tabBarController?.present(viewController, animated: true)
        myPageViewController = viewController
        myPageViewController?.didDisappear = {
            self.finish()
        }
    }
}
