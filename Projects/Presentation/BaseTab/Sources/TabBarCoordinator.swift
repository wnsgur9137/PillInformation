//
//  TabBarCoordinator.swift
//  Base
//
//  Created by JunHyeok Lee on 1/29/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit
import Common
import Home
import Search
import Alarm
import MyPage

public protocol TabBarCoordinator: Coordinator {
    var tabBarController: UITabBarController? { get set }
}

public final class DefaultTabBarCoordinator: TabBarCoordinator {
    
    public weak var finishDelegate: CoordinatorFinishDelegate?
    public weak var navigationController: UINavigationController?
    
    public var childCoordinators: [Common.Coordinator] = []
    public var type: CoordinatorType { .tab }
    
    public weak var tabBarController: UITabBarController?
    private let homeDependencies: HomeCoordinatorDependencies
    private let searchDependencies: SearchCoordinatorDependencies
    private let alarmDependencies: AlarmCoordinatorDependencies
    private let myPageDependencies: MyPageCoordinatorDependencies
    
    private weak var homeViewController: HomeViewController?
    private weak var serachViewController: SearchViewController?
    private weak var alarmViewController: AlarmViewController?
    private weak var myPageViewController: MyPageViewController?
    
    public init(tabBarController: UITabBarController,
                homeDependencies: HomeCoordinatorDependencies,
                searchDependencies: SearchCoordinatorDependencies,
                alarmDependencies: AlarmCoordinatorDependencies,
                myPageDependencies: MyPageCoordinatorDependencies) {
        self.tabBarController = tabBarController
        self.homeDependencies = homeDependencies
        self.searchDependencies = searchDependencies
        self.alarmDependencies = alarmDependencies
        self.myPageDependencies = myPageDependencies
    }
    
    public func start() {
        let pages: [TabBarPage] = [.home, .search, .alarm, .myPage]
        let controllers: [UINavigationController] = pages.map { getNavigationController($0) }
        prepareTabBarController(with: controllers)
    }
    
    private func getNavigationController(_ page: TabBarPage) -> UINavigationController {
        let navigationController = UINavigationController()
        navigationController.tabBarItem = UITabBarItem(title: page.title(), image: page.image(), selectedImage: page.selectedImage())
        
        switch page {
        case .home:
            let homeCoordinator = DefaultHomeCoordinator(navigationController: navigationController, dependencies: homeDependencies)
            homeCoordinator.finishDelegate = self
            homeCoordinator.start()
            childCoordinators.append(homeCoordinator)
            
        case .search:
            let searchCoordinator = DefaultSearchCoordinator(navigationController: navigationController, dependencies: searchDependencies)
            searchCoordinator.finishDelegate = self
            searchCoordinator.start()
            childCoordinators.append(searchCoordinator)
            
        case .alarm:
            let alarmCoordinator = DefaultAlarmCoordinator(navigationController: navigationController, dependencies: alarmDependencies)
            alarmCoordinator.finishDelegate = self
            alarmCoordinator.start()
            childCoordinators.append(alarmCoordinator)
            
        case .myPage:
            let myPageCoordinator = DefaultMyPageCoordinator(navigationController: navigationController, dependencies: myPageDependencies)
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
