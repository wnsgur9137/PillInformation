//
//  HealthDemoAppDIContainer.swift
//  MyPageDemoApp
//
//  Created by JunHyeok Lee on 6/28/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation

import Health
import NetworkInfra

final class HealthDemoAppDIContainer {
    private lazy var appConfiguration = HealthDemoAppConfiguration()
    
    private lazy var networkManager: NetworkManager = {
        return NetworkManager(withTest: false,
                              withFail: false,
                              baseURL: appConfiguration.apiBaseURL)
    }()
    
    func makeHealthDIContainer() -> HealthDIContainer {
        let dependencies = HealthDIContainer.Dependencies(networkManager: networkManager)
        return HealthDIContainer(dependencies: dependencies)
    }
}
