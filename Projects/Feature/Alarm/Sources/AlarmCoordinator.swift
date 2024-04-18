//
//  AlarmCoordinator.swift
//  Alarm
//
//  Created by JunHyeok Lee on 1/30/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit

import AlarmPresentation
import BasePresentation

public protocol AlarmCoordinatorDependencies {
    func makeAlarmTabBarController(viewControllers: [UIViewController]) -> AlarmTabBarController
    func makeAlarmViewController(flowAction: AlarmFlowAction) -> AlarmViewController
    func makeTimerViewController(flowAction: TimerFlowAction) -> TimerViewController
}

public protocol AlarmCoordinator: Coordinator {
    func showAlarmTabBarController()
}

public final class DefaultAlarmCoordinator: AlarmCoordinator {
    public weak var finishDelegate: CoordinatorFinishDelegate?
    public weak var navigationController: UINavigationController?
    public var childCoordinators: [Coordinator] = []
    public var type: CoordinatorType { .alarm }
    
    private let dependencies: AlarmCoordinatorDependencies
    private weak var alarmTabBarController: AlarmTabBarController?
    
    public init(navigationController: UINavigationController,
                dependencies: AlarmCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    public func start() {
        showAlarmTabBarController()
    }
    
    public func showAlarmTabBarController() {
        let alarmViewController = makeAlarmViewController()
        let timerViewController = makeTimerViewController()
        let viewController = dependencies.makeAlarmTabBarController(
            viewControllers: [
                alarmViewController,
                timerViewController
            ]
        )
        navigationController?.pushViewController(viewController, animated: false)
        alarmTabBarController = viewController
    }
    
    private func makeAlarmViewController() -> AlarmViewController {
        let flowAction = AlarmFlowAction()
        let alarmViewController =  dependencies.makeAlarmViewController(flowAction: flowAction)
        return alarmViewController
    }
    
    private func makeTimerViewController() -> TimerViewController {
        let flowAction = TimerFlowAction()
        let timerViewController = dependencies.makeTimerViewController(flowAction: flowAction)
        return timerViewController
    }
}
