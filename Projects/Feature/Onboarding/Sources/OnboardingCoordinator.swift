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
    func makeIntroViewController(flowAction: IntroFlowAction) -> IntroViewController
    func makeOnboardingPolicyViewController(user: UserModel?,
                                            flowAction: OnboardingPolicyFlowAction) -> OnboardingPolicyViewController
    func makeOnboardViewController(flowAction: OnboardFlowAction) -> OnboardViewController
}

public protocol OnboardingCoordinator: Coordinator {
    func startNonSignin()
    func showSignInViewController()
    func showOnboardingPolicyViewController(user: UserModel?)
}

public final class DefaultOnboardingCoordinator: OnboardingCoordinator {
    public weak var finishDelegate: CoordinatorFinishDelegate?
    public weak var navigationController: UINavigationController?
    public var childCoordinators: [Coordinator] = []
    public var type: CoordinatorType { .onboarding }
    
    private let dependencies: OnboardingCoordinatorDependencies
    private let appFlowDependencies: AppFlowDependencies
    
    private weak var signInViewController: SignInViewController?
    private weak var introViewController: IntroViewController?
    private weak var onboardingPolicyViewController: OnboardingPolicyViewController?
    private weak var policyViewController: PolicyViewController?
    private weak var onboardViewController: OnboardViewController?
    
    public init(navigationController: UINavigationController,
                dependencies: OnboardingCoordinatorDependencies,
                appFlowDependencies: AppFlowDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
        self.appFlowDependencies = appFlowDependencies
        navigationController.view.backgroundColor = Constants.Color.background
        navigationController.navigationBar.isHidden = true
    }
    
    public func start() {
        showSignInViewController()
    }
    
    public func startNonSignin() {
        showIntroViewController()
    }
    
    public func showSignInViewController() {
        let flowAction = SignInFlowAction(
            showOnboardingPolicyViewController: showOnboardingPolicyViewController,
            showMainScene: self.showMainScene
        )
        let viewController = dependencies.makeSignInViewController(flowAction: flowAction)
        navigationController?.pushViewController(viewController, animated: false)
        signInViewController = viewController
    }
    
    public func showIntroViewController() {
        let flowAction = IntroFlowAction(
            showOnboardingPolicyViewController: showOnboardingPolicyViewController, showOnboardViewController: showOnboardViewController
        )
        let viewController = dependencies.makeIntroViewController(flowAction: flowAction)
        navigationController?.pushViewController(viewController, animated: false)
        introViewController = viewController
    }
    
    public func showOnboardingPolicyViewController(user: UserModel?) {
        let flowAction = OnboardingPolicyFlowAction(
            popViewController: self.popViewController,
            showMainScene: self.showMainScene,
            showPolicyViewController: self.showPolicyViewController
        )
        let viewController = dependencies.makeOnboardingPolicyViewController(user: user,
                                                                             flowAction: flowAction)
        navigationController?.pushViewController(viewController, animated: true)
        onboardingPolicyViewController = viewController
    }
    
    public func showOnboardViewController() {
        let flowAction = OnboardFlowAction(
            popViewController: popViewController,
            showMainScene: showMainScene
        )
        let viewController = dependencies.makeOnboardViewController(flowAction: flowAction)
        navigationController?.pushViewController(viewController, animated: true)
        onboardViewController = viewController
    }
    
    private func popViewController(animated: Bool = true) {
        navigationController?.popViewController(animated: animated)
    }
    
    private func showMainScene() {
        appFlowDependencies.showMain()
    }
    
    private func showPolicyViewController(type: PolicyReactor.PolicyType) {
        let flowAction = PolicyFlowAction(popViewController: self.popViewController)
        let reactor = PolicyReactor(policyType: type, flowAction: flowAction)
        let viewController = PolicyViewController.create(with: reactor)
        navigationController?.pushViewController(viewController, animated: true)
        self.policyViewController = viewController
    }
}
