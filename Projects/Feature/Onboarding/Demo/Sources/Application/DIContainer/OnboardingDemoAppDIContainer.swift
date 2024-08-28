//
//  OnboardingDemoAppDIContainer.swift
//  OnboardingDemoApp
//
//  Created by JunHyoek Lee on 8/28/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation

import Onboarding
import NetworkInfra

final class OnboardingDemoAppDIContainer {
    private lazy var appConfiguration = OnboardingDemoAppConfiguration()
    
    private lazy var networkManager: NetworkManager = {
        return NetworkManager(
            withTest: false,
            withFail: false,
            baseURL: appConfiguration.apiBaseURL
        )
    }()
    
    func makeOnboardingDIContainer() -> OnboardingDIContainer {
        let dependencies = OnboardingDIContainer.Dependencies(
            networkManager: networkManager,
            isShowAlarmPrivacy: appConfiguration.isShowAlarmPrivacy
        )
        return OnboardingDIContainer(dependenceis: dependencies)
    }
}
