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
    private func makeAlarmRepository() -> AlarmRepository {
        return DefaultAlarmRepository()
    }
    private func makeAlarmUseCase() -> AlarmUseCase {
        return DefaultAlarmUseCase(alarmRepository: makeAlarmRepository())
    }
    public func makeAlarmTabBarController(viewControllers: [UIViewController]) -> AlarmTabBarController {
        return AlarmTabBarController.create(viewControllers: viewControllers)
    }
    private func makeAlarmReactor(flowAction: AlarmFlowAction) -> AlarmReactor {
        return AlarmReactor(with: makeAlarmUseCase(), flowAction: flowAction)
    }
    public func makeAlarmViewController(flowAction: AlarmFlowAction) -> AlarmViewController {
        return AlarmViewController.create(with: makeAlarmReactor(flowAction: flowAction))
    }
    private func makeAlarmDetailReactor(flowAction: AlarmDetailFlowAction, alarmModel: AlarmModel?) -> AlarmDetailReactor {
        return AlarmDetailReactor(with: makeAlarmUseCase(), alarmModel: alarmModel,flowAction: flowAction)
    }
    public func makeAlarmDetailViewController(flowAction: AlarmDetailFlowAction, alarmModel: AlarmModel?) -> AlarmDetailViewController {
        return AlarmDetailViewController.create(with: makeAlarmDetailReactor(flowAction: flowAction, alarmModel: alarmModel))
    }
    
    // Timer
    private func makeTimerRepository() -> TimerRepository {
        return DefaultTimerRepository()
    }
    private func makeTimerUseCase() -> TimerUseCase {
        return DefaultTimerUseCase(with: makeTimerRepository())
    }
    private func makeTimerReactor(flowAction: TimerFlowAction) -> TimerReactor {
        return TimerReactor(with: makeTimerUseCase(), flowAction: flowAction)
    }
    public func makeTimerViewController(flowAction: TimerFlowAction) -> TimerViewController {
        return TimerViewController.create(with: makeTimerReactor(flowAction: flowAction))
    }
    private func makeTimerDetailReactor(flowAction: TimerDetailFlowAction, timerModel: TimerModel?) -> TimerDetailReactor {
        return TimerDetailReactor(with: makeTimerUseCase(), flowAction: flowAction, timerModel: timerModel)
    }
    public func makeTimerDetailViewController(flowAction: TimerDetailFlowAction, timerModel: TimerModel?) -> TimerDetailViewController {
        return TimerDetailViewController.create(with: makeTimerDetailReactor(flowAction: flowAction, timerModel: timerModel))
    }
}

