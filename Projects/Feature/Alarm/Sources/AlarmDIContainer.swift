//
//  AlarmDIContainer.swift
//  Alarm
//
//  Created by JunHyeok Lee on 3/21/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit

import NetworkInfra
import AlarmData
import AlarmDomain
import AlarmPresentation

public final class AlarmDIContainer {
    public struct Dependencies {
        let networkManager: NetworkManager
        
        public init(networkManager: NetworkManager) {
            self.networkManager = networkManager
        }
    }
    
    let dependencies: Dependencies
    
    public init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
}

// MARK: - AlarmCoordinatorDependencies
extension AlarmDIContainer: AlarmCoordinatorDependencies {
    public func makeAlarmTabBarController(viewControllers: [UIViewController]) -> AlarmTabBarController {
        return AlarmTabBarController.create(viewControllers: viewControllers)
    }
    
    public func makeTimerReactor(flowAction: TimerFlowAction) -> TimerReactor {
        return TimerReactor(flowAction: flowAction)
    }
    
    public func makeTimerViewController(flowAction: TimerFlowAction) -> TimerViewController {
        return TimerViewController.create(with: makeTimerReactor(flowAction: flowAction))
    }
    
    public func makeAlarmReactor(flowAction: AlarmFlowAction) -> AlarmReactor {
        return AlarmReactor(flowAction: flowAction)
    }
    
    public func makeAlarmViewController(flowAction: AlarmFlowAction) -> AlarmViewController {
        return AlarmViewController.create(with: makeAlarmReactor(flowAction: flowAction))
    }
}

