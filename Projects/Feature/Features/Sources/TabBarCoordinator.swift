//
//  TabBarCoordinator.swift
//  BaseTab
//
//  Created by JunHyeok Lee on 3/20/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit

import Home
import Bookmark
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
    private let bookmarkDIContainer: BookmarkDIContainer
    private let searchDIContainer: SearchDIContainer
    private let alarmDIContainer: AlarmDIContainer
    private let myPageDIContainer: MyPageDIContainer
    
    public weak var navigationController: UINavigationController?
    public weak var tabBarController: UITabBarController?
    
    public init(tabBarController: UITabBarController,
                homeDIContainer: HomeDIContainer,
                bookmarkDIContainer: BookmarkDIContainer,
                searchDIContainer: SearchDIContainer,
                alarmDIContainer: AlarmDIContainer,
                myPageDIContainer: MyPageDIContainer) {
        self.tabBarController = tabBarController
        self.homeDIContainer = homeDIContainer
        self.bookmarkDIContainer = bookmarkDIContainer
        self.searchDIContainer = searchDIContainer
        self.alarmDIContainer = alarmDIContainer
        self.myPageDIContainer = myPageDIContainer
    }
    
    public func start() {
        let pages: [TabBarPage] = [.home, .bookmark, .search, .alarm]
        let controllers: [UINavigationController] = pages.map { getNavigationController($0) }
        prepareTabBarController(with: controllers)
    }
    
    private func getNavigationController(_ page: TabBarPage) -> UINavigationController {
        let navigationController = UINavigationController()
        navigationController.setNavigationBarHidden(true, animated: false)
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
            
        case .bookmark:
            let bookmarkCoordinator = DefaultBookmarkCoordinator(
                navigationController: navigationController,
                dependencies: bookmarkDIContainer,
                tabDependencies: self
            )
            bookmarkCoordinator.finishDelegate = self
            bookmarkCoordinator.start()
            
        case .search:
            let searchCoordinator = DefaultSearchCoordinator(
                navigationController: navigationController,
                dependencies: searchDIContainer,
                tabDependencies: self
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
        }
        
        return navigationController
    }
    
    private func prepareTabBarController(with controllers: [UINavigationController]) {
        tabBarController?.setViewControllers(controllers, animated: true)
        tabBarController?.selectedIndex = TabBarPage.home.orderNumber()
    }
    
    private func makeMyPageCoordinator() {
        guard let tabBarController = tabBarController else { return }
        let navigationController = UINavigationController()
        navigationController.setNavigationBarHidden(true, animated: false)
        let myPageCoordinator = DefaultMyPageCoordinator(
            tabBarController: tabBarController,
            navigationController: navigationController,
            dependencies: myPageDIContainer
        )
        myPageCoordinator.finishDelegate = self
        myPageCoordinator.start()
        childCoordinators.append(myPageCoordinator)
    }
    
    public func showMyPage() {
        guard let myPageCoordinator = childCoordinators.filter({ $0.type == .myPage }).first as? MyPageCoordinator else {
            print("maekMyPageCoordinator")
            makeMyPageCoordinator()
            return
        }
        myPageCoordinator.start()
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

// MARK: - BookmarkDependencies
extension DefaultTabBarCoordinator: BookmarkTabDependencies {
    
}

// MARK: - SearchDependencies
extension DefaultTabBarCoordinator: SearchTabDependencies {
    
}
