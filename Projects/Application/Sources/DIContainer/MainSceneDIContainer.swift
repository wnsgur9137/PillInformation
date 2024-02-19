//
//  MainSceneDIContainer.swift
//  Application
//
//  Created by JunHyeok Lee on 1/25/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit
import BaseTab
import Home
import Search
import Alarm
import MyPage

import HomeDomain
import HomeData

import NetworkInfra

final class MainSceneDIContainer {
    
    struct Dependencies {
        let networkManager: NetworkInfra.NetworkManager
    }
    
    let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func makeTabBarCoordinator(tabBarController: UITabBarController) -> TabBarCoordinator {
        return DefaultTabBarCoordinator(
            tabBarController: tabBarController,
            homeDependencies: self,
            searchDependencies: self,
            alarmDependencies: self,
            myPageDependencies: self
        )
    }
}

// MARK: - Home
extension MainSceneDIContainer: HomeCoordinatorDependencies {
    func makeHomeRepository() -> HomeDomain.HomeRepository {
        return HomeData.DefaultHomeRepository(networkManager: dependencies.networkManager)
    }
    
    // UseCase
    func makeHomeUseCase() -> HomeDomain.HomeUseCase {
        return HomeDomain.DefaultHomeUseCase(with: makeHomeRepository())
    }
    
    // Reactor
    func makeHomeReactor() -> Home.HomeReactor {
        return Home.HomeReactor(with: makeHomeUseCase())
    }
    
    // ViewController
    func makeHomeViewController() -> Home.HomeViewController {
        return Home.HomeViewController.create(with: makeHomeReactor())
    }
}

// MARK: - Search
extension MainSceneDIContainer: SearchCoordinatorDependencies {
    func makeSearchViewController() -> Search.SearchViewController {
        return Search.SearchViewController()
    }
}

// MARK: - Alarm
extension MainSceneDIContainer: AlarmCoordinatorDependencies {
    func makeAlarmViewController() -> Alarm.AlarmViewController {
        return Alarm.AlarmViewController()
    }
}

// MARK: - MyPage
extension MainSceneDIContainer: MyPageCoordinatorDependencies {
    func makeMyPageViewController() -> MyPage.MyPageViewController {
        return MyPage.MyPageViewController()
    }
}
