//
//  MyPageDemoAppDIContainer.swift
//  MyPageDemoApp
//
//  Created by JunHyeok Lee on 6/28/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation

import MyPage
import NetworkInfra

final class MyPageDemoAppDIContainer {
    private lazy var appConfiguration = MyPageDemoAppConfiguration()
    
    private lazy var networkManager: NetworkManager = {
        return NetworkManager(withTest: false,
                              withFail: false,
                              baseURL: appConfiguration.apiBaseURL)
    }()
    
    func makeMyPageDIContainer() -> MyPageDIContainer {
        let dependencies = MyPageDIContainer.Dependencies(networkManager: networkManager)
        return MyPageDIContainer(dependencies: dependencies)
    }
}
