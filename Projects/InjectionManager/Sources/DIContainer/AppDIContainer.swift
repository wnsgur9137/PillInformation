//
//  AppDIContainer.swift
//  InjectionManager
//
//  Created by JunHyoek Lee on 8/21/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation

import NetworkInfra

public final class AppDIContainer {
    public lazy var appConfiguration = AppConfiguration()
    
    private lazy var networkManager: NetworkManager = {
        return NetworkManager(withTest: false,
                              withFail: false,
                              baseURL: appConfiguration.apiBaseURL)
    }()
    
    public init() {
        
    }
    
    public func makeMainSceneDIContainer() -> MainSceneDIContainer {
        let dependencies = MainSceneDIContainer.Dependencies(
            networkManager: networkManager,
            isShowAlarmPrivacy: appConfiguration.isShowAlarmPrivacy
        )
        return MainSceneDIContainer(dependencies: dependencies)
    }
    
    public func makeSplashSceneDIContainer() -> SplashSceneDIContainer {
        let dependencies = SplashSceneDIContainer.Dependencies(networkManager: networkManager)
        return SplashSceneDIContainer(dependencies: dependencies)
    }
    
    public func makeOnboardingSceneDIContainer() -> OnboardingSceneDIContainer {
        let dependencies = OnboardingSceneDIContainer.Dependencies(
            networkManager: networkManager,
            isShowAlarmPrivacy: appConfiguration.isShowAlarmPrivacy
        )
        return OnboardingSceneDIContainer(dependencies: dependencies)
    }
}
