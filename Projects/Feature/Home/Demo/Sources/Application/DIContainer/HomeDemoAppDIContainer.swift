//
//  HomeDemoAppDIContainer.swift
//  HomeDemoApp
//
//  Created by JunHyoek Lee on 8/28/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation

import Home
import NetworkInfra

final class HomeDemoAppDIContainer {
    private lazy var appConfiguration = HomeDemoAppConfiguration()
    
    private lazy var networkManager: NetworkManager = {
        return NetworkManager(
            withTest: false,
            withFail: false,
            baseURL: appConfiguration.apiBaseURL
        )
    }()
    
    func makeHomeDIContainer() -> HomeDIContainer {
        let dependencies = HomeDIContainer.Dependencies(networkManager: networkManager)
        return HomeDIContainer(dependencies: dependencies)
    }
}
