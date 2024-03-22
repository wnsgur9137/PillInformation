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
    func makeMyPageViewController() -> MyPageViewController
}

public protocol MyPageCoordinator: Coordinator {
    func showMyPageViewController()
}

public final class DefaultMyPageCoordinator: MyPageCoordinator {
    public weak var finishDelegate: CoordinatorFinishDelegate?
    public weak var navigationController: UINavigationController?
    public var childCoordinators: [Coordinator] = []
    public var type: CoordinatorType { .myPage }
    
    private let dependencies: MyPageCoordinatorDependencies
    private weak var myPageViewController: MyPageViewController?
    
    public init(navigationController: UINavigationController,
                dependencies: MyPageCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    public func start() {
        showMyPageViewController()
    }
    
    public func showMyPageViewController() {
        let viewController = dependencies.makeMyPageViewController()
        navigationController?.pushViewController(viewController, animated: false)
        myPageViewController = viewController
    }
}
