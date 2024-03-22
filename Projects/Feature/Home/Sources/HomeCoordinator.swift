//
//  HomeCoordinator.swift
//  Home
//
//  Created by JunHyeok Lee on 1/30/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit

import HomePresentation
import BasePresentation

public protocol HomeCoordinatorDependencies {
    func makeHomeViewController(flowAction: HomeFlowAction) -> HomeViewController
    func makeNoticeDetailViewController(notice: NoticeModel, flowAction: NoticeDetailFlowAction) -> NoticeDetailViewController
}

public protocol HomeTabDependencies {
    func changeTab(index: Int)
}

public protocol HomeCoordinator: Coordinator {
    func showHomeViewController()
}

public final class DefaultHomeCoordinator: HomeCoordinator {
    public weak var finishDelegate: CoordinatorFinishDelegate?
    public weak var navigationController: UINavigationController?
    public var childCoordinators: [Coordinator] = []
    public var type: CoordinatorType { .home }
    
    private let dependencies: HomeCoordinatorDependencies
    private let tabDependencies: HomeTabDependencies
    private weak var homeViewController: HomeViewController?
    private weak var noticeDetailViewController: NoticeDetailViewController?
    
    public init(navigationController: UINavigationController,
                dependencies: HomeCoordinatorDependencies,
                tabDependencies: HomeTabDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
        self.tabDependencies = tabDependencies
    }
    
    public func start() {
        showHomeViewController()
    }
    
    public func showHomeViewController() {
        let flowAction = HomeFlowAction(
            showNoticeDetailViewController: showNoticeDetailViewController,
            changeTabIndex: tabDependencies.changeTab
        )
        let viewController = dependencies.makeHomeViewController(flowAction: flowAction)
        navigationController?.pushViewController(viewController, animated: false)
        homeViewController = viewController
    }
    
    private func showNoticeDetailViewController(notice: NoticeModel) {
        let flowAction = NoticeDetailFlowAction(showNoticeDetailViewController: showNoticeDetailViewController)
        let viewController = dependencies.makeNoticeDetailViewController(notice: notice, flowAction: flowAction)
        navigationController?.pushViewController(viewController, animated: true)
        noticeDetailViewController = viewController
    }
}
