//
//  AlarmDemoAppDIContainer.swift
//  AlarmDemoApp
//
//  Created by JunHyeok Lee on 4/22/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation

import NetworkInfra

final class AlarmDemoAppDIContainer {
    lazy var appConfiguration = AlarmDemoAppConfiguration()
    
    lazy var networkManager: NetworkManager = {
        return NetworkManager(withTest: false,
                              withFail: false,
                              baseURL: appConfiguration.apiBaseURL)
    }()
    
    func makeAlarmDIContainer() -> AlarmDIContainer {
        let dependencies = AlarmDIContainer.Dependencies(networkManager: networkManager)
        return AlarmDIContainer(dependencies: dependencies)
    }
}
