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
import SearchDomain
import SearchData
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
        return DefaultNoticeUseCase(with: makeNoticeRepository())
    }
    
    // Home
    func makeHomeReactor(flowAction: HomeFlowAction) -> Home.HomeReactor {
        return HomeReactor(with: makeNoticeUseCase(),
                                flowAction: flowAction)
    }
    func makeHomeViewController(flowAction: HomeFlowAction) -> Home.HomeViewController {
        return HomeViewController.create(with: makeHomeReactor(flowAction: flowAction))
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
    func makeSearchRepository() -> SearchDomain.SearchRepository {
        return SearchData.DefaultSearchRepository(networkManager: dependencies.networkManager)
    }
    func makeSearchUseCase() -> SearchDomain.SearchUseCase {
        return DefaultSearchUseCase(with: makeSearchRepository())
    }
    func makeSearchReactor(flowAction: SearchFlowAction) -> Search.SearchReactor {
        return SearchReactor(with: makeSearchUseCase(), flowAction: flowAction)
    }
    func makeSearchViewController(flowAction: SearchFlowAction) -> Search.SearchViewController {
        return SearchViewController().create(with: makeSearchReactor(flowAction: flowAction))
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
