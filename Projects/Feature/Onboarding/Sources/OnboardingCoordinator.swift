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
    func showMainScene()
    func makeSignInViewController() -> SignInViewController
}

public protocol OnboardingCoordinator: Coordinator {
    func showSignInViewController()
}

public final class DefaultOnboardingCoordinator: OnboardingCoordinator {
    public weak var finishDelegate: CoordinatorFinishDelegate?
    public weak var navigationController: UINavigationController?
    public var childCoordinators: [Coordinator] = []
    public var type: CoordinatorType { .onboarding }
    
    private let dependencies: OnboardingCoordinatorDependencies
    private weak var signInViewController: SignInViewController?
    
    public init(navigationController: UINavigationController,
                dependencies: OnboardingCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
        navigationController.view.backgroundColor = Constants.Color.background
    }
    
    public func start() {
        showSignInViewController()
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            NotificationCenter.default.post(name: Notification.Name("showMainScene"), object: nil)
//        }
    }
    
    public func showSignInViewController() {
        let viewController = dependencies.makeSignInViewController()
        navigationController?.pushViewController(viewController, animated: false)
        signInViewController = viewController
    }
}
