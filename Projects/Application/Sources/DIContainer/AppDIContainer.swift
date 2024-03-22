//
//  AppDIContainer.swift
//  Application
//
//  Created by JunHyeok Lee on 1/25/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation

import NetworkInfra

final class AppDIContainer {
    lazy var appConfiguration = AppConfiguration()
    
    lazy var networkManager: NetworkManager = {
        return NetworkManager(withTest: false,
                                           withFail: false,
                                           baseURL: appConfiguration.apiBaseURL)
    }()
    
    func makeMainSceneDIContainer() -> MainSceneDIContainer {
        let dependencies = MainSceneDIContainer.Dependencies(networkManager: networkManager)
        return MainSceneDIContainer(dependencies: dependencies)
    }
}
