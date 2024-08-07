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
import Home
import Bookmark
import Search
import Alarm
import MyPage
import Health

final class MainSceneDIContainer {
    
    struct Dependencies {
        let networkManager: NetworkManager
        let isShowAlarmPrivacy: Bool
    }
    
    let dependencies: Dependencies

    private let homeDIContainer: HomeDIContainer
    private let bookmarkDIContainer: BookmarkDIContainer
    private let searchDIContainer: SearchDIContainer
    private let alarmDIContainer: AlarmDIContainer
    private let myPageDIContainer: MyPageDIContainer
    private let healthDIContainer: HealthDIContainer

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
        self.homeDIContainer = HomeDIContainer(dependencies: .init(
            networkManager: dependencies.networkManager
        ))
        self.bookmarkDIContainer = BookmarkDIContainer(dependencies: .init(
            networkManager: dependencies.networkManager
        ))
        self.searchDIContainer = SearchDIContainer(dependencies: .init(
            networkManager: dependencies.networkManager
        ))
        self.alarmDIContainer = AlarmDIContainer(dependencies: .init(
            networkManager: dependencies.networkManager
        ))
        self.myPageDIContainer = MyPageDIContainer(dependencies: .init(
            networkManager: dependencies.networkManager,
            isShowAlarmPrivacy: dependencies.isShowAlarmPrivacy
        ))
        self.healthDIContainer = HealthDIContainer(dependencies: .init(
            networkManager: dependencies.networkManager
        ))
    }
    
    func makeTabBarCoordinator(tabBarController: UITabBarController,
                               isShowAlarmTab: Bool) -> TabBarCoordinator {
        return DefaultTabBarCoordinator(
            tabBarController: tabBarController,
            homeDIContainer: homeDIContainer,
            bookmarkDIContainer: bookmarkDIContainer,
            searchDIContainer: searchDIContainer,
            alarmDIContainer: alarmDIContainer,
            myPageDIContainer: myPageDIContainer,
            healthDIContainer: healthDIContainer,
            isShowAlarmTab: isShowAlarmTab
        )
    }
}
