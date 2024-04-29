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
    // Alarm
    public func makeAlarmTabBarController(viewControllers: [UIViewController]) -> AlarmTabBarController {
        return AlarmTabBarController.create(viewControllers: viewControllers)
    }
    public func makeAlarmReactor(flowAction: AlarmFlowAction) -> AlarmReactor {
        return AlarmReactor(flowAction: flowAction)
    }
    public func makeAlarmViewController(flowAction: AlarmFlowAction) -> AlarmViewController {
        return AlarmViewController.create(with: makeAlarmReactor(flowAction: flowAction))
    }
    
    // Timer
    public func makeTimerRepository() -> TimerRepository {
        return DefaultTimerRepository()
    }
    public func makeTimerUseCase() -> TimerUseCase {
        return DefaultTimerUseCase(with: makeTimerRepository())
    }
    public func makeTimerReactor(flowAction: TimerFlowAction) -> TimerReactor {
        return TimerReactor(with: makeTimerUseCase(), flowAction: flowAction)
    }
    public func makeTimerViewController(flowAction: TimerFlowAction) -> TimerViewController {
        return TimerViewController.create(with: makeTimerReactor(flowAction: flowAction))
    }
    public func makeTimerDetailReactor(flowAction: TimerDetailFlowAction, timerModel: TimerModel?) -> TimerDetailReactor {
        return TimerDetailReactor(with: makeTimerUseCase(), flowAction: flowAction, timerModel: timerModel)
    }
    public func makeTimerDetailViewController(flowAction: TimerDetailFlowAction, timerModel: TimerModel?) -> TimerDetailViewController {
        return TimerDetailViewController.create(with: makeTimerDetailReactor(flowAction: flowAction, timerModel: timerModel))
    }
}

