//
//  MainSceneDIContainer.swift
//  PillInformation
//
//  Created by JunHyeok Lee on 3/20/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit

import Features
import NetworkInfra
import Onboarding
import Home
import Search
import Alarm
import MyPage

final class MainSceneDIContainer {
    
    struct Dependencies {
        let networkManager: NetworkManager
    }
    
    let dependencies: Dependencies

    private let homeDIContainer: HomeDIContainer
    private let searchDIContainer: SearchDIContainer
    private let alarmDIContainer: AlarmDIContainer
    private let myPageDIContainer: MyPageDIContainer

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
        self.homeDIContainer = HomeDIContainer(dependencies: .init(networkManager: dependencies.networkManager))
        self.searchDIContainer = SearchDIContainer(dependencies: .init(networkManager: dependencies.networkManager))
        self.alarmDIContainer = AlarmDIContainer(dependencies: .init(networkManager: dependencies.networkManager))
        self.myPageDIContainer = MyPageDIContainer(dependencies: .init(networkManager: dependencies.networkManager))
    }
    
    func makeTabBarCoordinator(tabBarController: UITabBarController) -> TabBarCoordinator {
        return DefaultTabBarCoordinator(
            tabBarController: tabBarController,
            homeDIContainer: homeDIContainer,
            searchDIContainer: searchDIContainer,
            alarmDIContainer: alarmDIContainer,
            myPageDIContainer: myPageDIContainer
        )
    }
}
