//
//  SearchDemoAppDIContainer.swift
//  SearchDemoApp
//
//  Created by JunHyeok Lee on 5/7/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation

import Search
import NetworkInfra

final class SearchDemoAppDIContainer {
    private lazy var appConfiguration = SearchDemoAppConfiguration()
    
    private lazy var networkManager: NetworkManager = {
        return NetworkManager(withTest: false,
                              withFail: false,
                              baseURL: appConfiguration.apiBaseURL)
    }()
    
    func makeSearchDIContainer() -> SearchDIContainer {
        let dependencies = SearchDIContainer.Dependencies(networkManager: networkManager)
        return SearchDIContainer(dependencies: dependencies)
    }
}
