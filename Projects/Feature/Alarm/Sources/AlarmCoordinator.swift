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
    func makeAlarmViewController(flowAction: AlarmFlowAction) -> AlarmViewController
}

public protocol AlarmCoordinator: Coordinator {
    func showAlarmViewController()
}

public final class DefaultAlarmCoordinator: AlarmCoordinator {
    public weak var finishDelegate: CoordinatorFinishDelegate?
    public weak var navigationController: UINavigationController?
    public var childCoordinators: [Coordinator] = []
    public var type: CoordinatorType { .alarm }
    
    private let dependencies: AlarmCoordinatorDependencies
    private weak var alarmViewController: AlarmViewController?
    
    public init(navigationController: UINavigationController,
                dependencies: AlarmCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    public func start() {
        showAlarmViewController()
    }
    
    public func showAlarmViewController() {
        let flowAction = AlarmFlowAction()
        let viewController =  dependencies.makeAlarmViewController(flowAction: flowAction)
        navigationController?.pushViewController(viewController, animated: false)
        alarmViewController = viewController
    }
}
