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
import AcknowList

public protocol MyPageCoordinatorDependencies {
    func makeMyPageViewController(flowAction: MyPageFlowAction) -> MyPageViewController
    func makeAlarmSettingViewController(flowAction: AlarmSettingFlowAction) -> AlarmSettingViewController
    func makePolicyViewController(policyType: PolicyType, flowAction: PolicyFlowAction) -> PolicyViewController
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
    
    public init(tabBarController: UITabBarController?,
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
            showOpenSourceLicenseViewController: showOpenSourceLicenseViewController,
            showOnboardingScene: showOnboardingScene
        )
        let viewController = dependencies.makeMyPageViewController(flowAction: flowAction)
        
        navigationController?.pushViewController(viewController, animated: false)
        guard let navigationController = navigationController else { return }
        navigationController.modalPresentationStyle = .overFullScreen
        tabBarController?.present(navigationController, animated: true)
        myPageViewController = viewController
        myPageViewController?.didDisappear = {
            self.finish()
        }
    }
    
    private func showAlarmSettingViewController() {
        let flowAction = AlarmSettingFlowAction(
            popViewController: popViewController
        )
        let viewController = dependencies.makeAlarmSettingViewController(flowAction: flowAction)
        navigationController?.pushViewController(viewController, animated: true)
        alarmSettingViewController = viewController
    }
    
    private func showPolicyViewController(_ policyType: PolicyType) {
        let flowAction = PolicyFlowAction()
        let viewController = dependencies.makePolicyViewController(
            policyType: policyType,
            flowAction: flowAction
        )
        navigationController?.pushViewController(viewController, animated: true)
        policyViewController = viewController
    }
    
    private func showOpenSourceLicenseViewController() {
        let viewController = AcknowListViewController()
        viewController.title = "OpenSource License"
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func popViewController(_ animated: Bool) {
        navigationController?.popViewController(animated: animated)
    }
    
    private func showOnboardingScene() {
        NotificationCenter.default.post(name: Notification.Name("showOnboardingScene"), object: nil)
    }
}
