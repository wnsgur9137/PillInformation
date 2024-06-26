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
    func makeAlarmSettingViewController(flowAction: AlarmSettingFlowAction) -> AlarmSettingViewController
    func makePolicyViewController(flowAction: PolicyFlowAction) -> PolicyViewController
    func makeOpenSourceLicenseViewController(flowAction: OpenSourceLicenseFlowAction) -> OpenSourceLicenseViewController
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
    private weak var alarmSettingViewController: AlarmSettingViewController?
    private weak var policyViewController: PolicyViewController?
    private weak var openSourceLicenseViewController: OpenSourceLicenseViewController?
    
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
        let flowAction = MyPageFlowAction(
            showAlarmSettingViewController: showAlarmSettingViewController,
            showPolicyViewController: showPolicyViewController,
            showOpenSourceLicenseViewController: showOpenSourceLicenseViewController
        )
        let viewController = dependencies.makeMyPageViewController(flowAction: flowAction)
        tabBarController?.present(viewController, animated: true)
        myPageViewController = viewController
        myPageViewController?.didDisappear = {
            self.finish()
        }
    }
    
    private func showAlarmSettingViewController() {
        let flowAction = AlarmSettingFlowAction()
        let viewController = dependencies.makeAlarmSettingViewController(flowAction: flowAction)
        navigationController?.pushViewController(viewController, animated: true)
        alarmSettingViewController = viewController
    }
    
    private func showPolicyViewController(_ policy: Policy) {
        let flowAction = PolicyFlowAction()
        let viewController = dependencies.makePolicyViewController(flowAction: flowAction)
        navigationController?.pushViewController(viewController, animated: true)
        policyViewController = viewController
    }
    
    private func showOpenSourceLicenseViewController() {
        let flowAction = OpenSourceLicenseFlowAction()
        let viewController = dependencies.makeOpenSourceLicenseViewController(flowAction: flowAction)
        navigationController?.pushViewController(viewController, animated: true)
        openSourceLicenseViewController = viewController
    }
}
