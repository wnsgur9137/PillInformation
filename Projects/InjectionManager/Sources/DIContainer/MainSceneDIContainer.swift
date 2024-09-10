//
//  MainSceneDIContainer.swift
//  InjectionManager
//
//  Created by JunHyoek Lee on 8/21/24.
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
import BasePresentation

public final class MainSceneDIContainer {
    
    struct Dependencies {
        let networkManager: NetworkManager
        let isShowAlarmPrivacy: Bool
    }
    
    let dependencies: Dependencies
    private let appFlowDependencies: AppFlowDependencies

    private let homeDIContainer: HomeDIContainer
    private let bookmarkDIContainer: BookmarkDIContainer
    private let searchDIContainer: SearchDIContainer
    private let alarmDIContainer: AlarmDIContainer
    private let myPageDIContainer: MyPageDIContainer

    init(dependencies: Dependencies,
         appFlowDependencies: AppFlowDependencies) {
        self.dependencies = dependencies
        self.appFlowDependencies = appFlowDependencies
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
    }
    
    public func makeTabBarCoordinator(tabBarController: UITabBarController,
                               isShowAlarmTab: Bool) -> TabBarCoordinator {
        return DefaultTabBarCoordinator(
            tabBarController: tabBarController,
            appFlowDependencies: appFlowDependencies,
            homeDIContainer: homeDIContainer,
            bookmarkDIContainer: bookmarkDIContainer,
            searchDIContainer: searchDIContainer,
            alarmDIContainer: alarmDIContainer,
            myPageDIContainer: myPageDIContainer,
            isShowAlarmTab: isShowAlarmTab
        )
    }
}
