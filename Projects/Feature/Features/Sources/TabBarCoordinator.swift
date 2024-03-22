//
//  TabBarCoordinator.swift
//  BaseTab
//
//  Created by JunHyeok Lee on 3/20/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit

import Home
import Search
import Alarm
import MyPage
import BasePresentation

public protocol TabBarCoordinator: Coordinator {
    var tabBarController: UITabBarController? { get set }
}

public final class DefaultTabBarCoordinator: TabBarCoordinator {
    
    public weak var finishDelegate: CoordinatorFinishDelegate?
    public var childCoordinators: [Coordinator] = []
    public var type: CoordinatorType { .tab }
    
    private let homeDIContainer: HomeDIContainer
    private let searchDIContainer: SearchDIContainer
    private let alarmDIContainer: AlarmDIContainer
    private let myPageDIContainer: MyPageDIContainer
    
    public weak var navigationController: UINavigationController?
    public weak var tabBarController: UITabBarController?
    
    public init(tabBarController: UITabBarController,
                homeDIContainer: HomeDIContainer,
                searchDIContainer: SearchDIContainer,
                alarmDIContainer: AlarmDIContainer,
                myPageDIContainer: MyPageDIContainer) {
        self.tabBarController = tabBarController
        self.homeDIContainer = homeDIContainer
        self.searchDIContainer = searchDIContainer
        self.alarmDIContainer = alarmDIContainer
        self.myPageDIContainer = myPageDIContainer
    }
    
    public func start() {
        let pages: [TabBarPage] = [.home, .search, .alarm, .myPage]
        let controllers: [UINavigationController] = pages.map { getNavigationController($0) }
        prepareTabBarController(with: controllers)
    }
    
    private func getNavigationController(_ page: TabBarPage) -> UINavigationController {
        let navigationController = UINavigationController()
        navigationController.tabBarItem = UITabBarItem(title: page.title(),
                                                       image: page.image(),
                                                       selectedImage: page.selectedImage())
        
        switch page {
        case .home:
            let homeCoordinator = DefaultHomeCoordinator(
                navigationController: navigationController,
                dependencies: homeDIContainer,
                tabDependencies: self
            )
            homeCoordinator.finishDelegate = self
            homeCoordinator.start()
            childCoordinators.append(homeCoordinator)
        
        case .search:
            let searchCoordinator = DefaultSearchCoordinator(
                navigationController: navigationController,
                dependencies: searchDIContainer
            )
            searchCoordinator.finishDelegate = self
            searchCoordinator.start()
            childCoordinators.append(searchCoordinator)
            
        case .alarm:
            let alarmCoordinator = DefaultAlarmCoordinator(
                navigationController: navigationController,
                dependencies: alarmDIContainer
            )
            alarmCoordinator.finishDelegate = self
            alarmCoordinator.start()
            childCoordinators.append(alarmCoordinator)
            
        case .myPage:
            let myPageCoordinator = DefaultMyPageCoordinator(
                navigationController: navigationController,
                dependencies: myPageDIContainer
            )
            myPageCoordinator.finishDelegate = self
            myPageCoordinator.start()
            childCoordinators.append(myPageCoordinator)
        }
        
        return navigationController
    }
    
    private func prepareTabBarController(with controllers: [UINavigationController]) {
        tabBarController?.setViewControllers(controllers, animated: true)
        tabBarController?.selectedIndex = TabBarPage.home.orderNumber()
        tabBarController?.tabBar.isTranslucent = false
        tabBarController?.tabBar.barTintColor = Constants.Color.systemBackground
        tabBarController?.view.backgroundColor = Constants.Color.systemBackground
    }
}

// MARK: - CoordinatorFinishDelegate
extension DefaultTabBarCoordinator: CoordinatorFinishDelegate {
    public func coordinatorDidFinish(childCoordinator: Coordinator) {
        childCoordinators = childCoordinators.filter{ $0.type != childCoordinator.type }
        navigationController?.viewControllers.removeAll()
//        switch childCoordinator.type {
//        case .home:
//            navigationController?.viewControllers.removeAll()
//        case .search:
//            navigationController?.viewControllers.removeAll()
//        case .alarm:
//            navigationController?.viewControllers.removeAll()
//        case .myPage:
//            navigationController?.viewControllers.removeAll()
//        default:
//            break
//        }
    }
}

// MARK: - HomeTabDependencies
extension DefaultTabBarCoordinator: HomeTabDependencies {
    public func changeTab(index: Int) {
        tabBarController?.selectedIndex = index
    }
}
