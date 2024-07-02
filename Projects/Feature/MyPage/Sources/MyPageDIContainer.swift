//
//  MyPageDIContainer.swift
//  MyPage
//
//  Created by JunHyeok Lee on 3/21/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation

import NetworkInfra
import BaseData
import MyPageData
import MyPageDomain
import MyPagePresentation

public final class MyPageDIContainer {
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

// MARK: - MyPageCoordinatorDependencies
extension MyPageDIContainer: MyPageCoordinatorDependencies {
    private func makeUserUseCase() -> UserUseCase {
        return DefaultUserMyPageUseCase(with: makeUserMyPageRepository())
    }
    private func makeMyPageReactor(flowAction: MyPageFlowAction) -> MyPageReactor {
        return MyPageReactor(with: makeUserUseCase(), flowAction: flowAction)
    }
    public func makeMyPageViewController(flowAction: MyPageFlowAction) -> MyPageViewController {
        return MyPageViewController.create(with: makeMyPageReactor(flowAction: flowAction))
    }
    
    private func makeUserRepository() -> UserRepository {
        return DefaultUserRepository(networkManager: dependencies.networkManager)
    }
    private func makeUserMyPageRepository() -> UserMyPageRepository {
        return DefaultUserMyPageRepository(userRepository: makeUserRepository())
    }
    private func makeAlarmSettingUseCase() -> AlarmSettingUseCase {
        return DefaultAlarmSettingUseCase(with: makeUserMyPageRepository())
    }
    private func makeAlarmSettingReactor(flowAction: AlarmSettingFlowAction) -> AlarmSettingReactor {
        return AlarmSettingReactor(with: makeAlarmSettingUseCase(), flowAction: flowAction)
    }
    public func makeAlarmSettingViewController(flowAction: AlarmSettingFlowAction) -> AlarmSettingViewController {
        return AlarmSettingViewController.create(with: makeAlarmSettingReactor(flowAction: flowAction))
    }
    
    private func makePolicyReactor(policyType: PolicyType, flowAction: PolicyFlowAction) -> PolicyReactor {
        return PolicyReactor(policyType: policyType, flowAction: flowAction)
    }
    public func makePolicyViewController(policyType: PolicyType, flowAction: PolicyFlowAction) -> PolicyViewController {
        return PolicyViewController.create(with: makePolicyReactor(policyType: policyType, flowAction: flowAction))
    }
}
