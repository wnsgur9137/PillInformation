//
//  OnboardingCoordinator.swift
//  Onboarding
//
//  Created by JunHyeok Lee on 3/28/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit

import OnboardingPresentation
import BasePresentation

public protocol OnboardingCoordinatorDependencies {
    func makeSignInViewController(flowAction: SignInFlowAction) -> SignInViewController
    func makeOnboardingPolicyViewController(flowAction: OnboardingPolicyFlowAction) -> OnboardingPolicyViewController
}

public protocol OnboardingCoordinator: Coordinator {
    func showSignInViewController()
    func showOnboardingPolicyViewController()
}

public final class DefaultOnboardingCoordinator: OnboardingCoordinator {
    public weak var finishDelegate: CoordinatorFinishDelegate?
    public weak var navigationController: UINavigationController?
    public var childCoordinators: [Coordinator] = []
    public var type: CoordinatorType { .onboarding }
    
    private let dependencies: OnboardingCoordinatorDependencies
    private weak var signInViewController: SignInViewController?
    private weak var onboardingPolicyViewController: OnboardingPolicyViewController?
    
    public init(navigationController: UINavigationController,
                dependencies: OnboardingCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
        navigationController.view.backgroundColor = Constants.Color.background
        navigationController.navigationBar.isHidden = true
    }
    
    public func start() {
        showSignInViewController()
    }
    
    public func showSignInViewController() {
        let flowAction = SignInFlowAction(showOnboardingPolicyViewController: showOnboardingPolicyViewController)
        let viewController = dependencies.makeSignInViewController(flowAction: flowAction)
        navigationController?.pushViewController(viewController, animated: false)
        signInViewController = viewController
    }
    
    public func showOnboardingPolicyViewController() {
        let flowAction = OnboardingPolicyFlowAction(
            popViewController: self.popViewController,
            showMainScene: self.showMainScene
        )
        let viewController = dependencies.makeOnboardingPolicyViewController(flowAction: flowAction)
        navigationController?.pushViewController(viewController, animated: true)
        onboardingPolicyViewController = viewController
    }
    
    private func popViewController(animated: Bool = true) {
        navigationController?.popViewController(animated: animated)
    }
    
    private func showMainScene() {
        NotificationCenter.default.post(name: Notification.Name("showMainScene"), object: nil)
    }
}
