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
    // Notice
    func makeNoticeRepository() -> HomeDomain.NoticeRepository {
        return HomeData.DefaultNoticeRepository(networkManager: dependencies.networkManager)
    }
    func makeNoticeUseCase() -> HomeDomain.NoticeUseCase {
        return HomeDomain.DefaultNoticeUseCase(with: makeNoticeRepository())
    }
    
    // Home
    func makeHomeReactor(flowAction: HomeFlowAction) -> Home.HomeReactor {
        return Home.HomeReactor(with: makeNoticeUseCase(),
                                flowAction: flowAction)
    }
    func makeHomeViewController(flowAction: HomeFlowAction) -> Home.HomeViewController {
        return Home.HomeViewController.create(with: makeHomeReactor(flowAction: flowAction))
    }
    
    // NoticeDetail
    func makeNoticeDetailReactor(notice: Notice, 
                                 flowAction: NoticeDetailFlowAction) -> NoticeDetailReactor {
        return NoticeDetailReactor(notice: notice,
                                   noticeUseCase: makeNoticeUseCase(),
                                   flowAction: flowAction)
    }
    func makeNoticeDetailViewController(notice: Notice, 
                                        flowAction: NoticeDetailFlowAction) -> NoticeDetailViewController {
        return NoticeDetailViewController.create(with: makeNoticeDetailReactor(notice: notice, flowAction: flowAction))
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
