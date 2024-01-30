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

final class MainSceneDIContainer {
    init() {
        
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
    func makeHomeViewController() -> Home.HomeViewController {
        return HomeViewController()
    }
}

// MARK: - Search
extension MainSceneDIContainer: SearchCoordinatorDependencies {
    func makeSearchViewController() -> Search.SearchViewController {
        return SearchViewController()
    }
}

// MARK: - Alarm
extension MainSceneDIContainer: AlarmCoordinatorDependencies {
    func makeAlarmViewController() -> Alarm.AlarmViewController {
        return AlarmViewController()
    }
}

// MARK: - MyPage
extension MainSceneDIContainer: MyPageCoordinatorDependencies {
    func makeMyPageViewController() -> MyPage.MyPageViewController {
        return MyPageViewController()
    }
}
