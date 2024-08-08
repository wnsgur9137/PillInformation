//
//  HomeCoordinator.swift
//  Home
//
//  Created by JunHyeok Lee on 1/30/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit

import HomePresentation
import BasePresentation

public protocol HomeCoordinatorDependencies {
    func makeHomeViewController(flowAction: HomeFlowAction, homeTabViewController: HomeTabViewController) -> HomeViewControllerV1
    func makeHomeTabViewController(tabViewControllers: [UIViewController], tabTitles: [String], isNewTabs: [Bool]) -> HomeTabViewController
    func makeHomeRecommendViewController(flowAction: HomeRecommendFlowAction) -> HomeRecommendViewController
    func makeHomeNoticeViewController(flowAction: HomeNoticeFlowAction) -> HomeNoticeViewController
    
    func makeHomeViewController(flowAction: HomeFlowAction) -> HomeViewController
    func makeSearchDetailViewController(pillInfo: PillInfoModel, flowAction: SearchDetailFlowAction) -> SearchDetailViewControllerProtocol
    func makeImageDetailViewController(pillName: String, className: String?, imageURL: URL, flowAction: ImageDetailFlowAction) -> ImageDetailViewController
    func makeNoticeDetailViewController(notice: NoticeModel, flowAction: NoticeDetailFlowAction) -> NoticeDetailViewController
}

public protocol HomeTabDependencies {
    func changeTab(index: Int)
    func showSearchTab()
    func showShapeSearchViewController()
    func showMyPageViewController()
}

public protocol HomeCoordinator: Coordinator {
    func showHomeViewController()
}

public final class DefaultHomeCoordinator: HomeCoordinator {
    public weak var finishDelegate: CoordinatorFinishDelegate?
    public weak var navigationController: UINavigationController?
    public var childCoordinators: [Coordinator] = []
    public var type: CoordinatorType { .home }
    
    private let dependencies: HomeCoordinatorDependencies
    private let tabDependencies: HomeTabDependencies
    private weak var homeViewController: HomeViewController?
    private weak var noticeDetailViewController: NoticeDetailViewController?
    private weak var searchDetailViewController: SearchDetailViewControllerProtocol?
    private weak var imageDetailViewController: ImageDetailViewController?
    
    public init(navigationController: UINavigationController,
                dependencies: HomeCoordinatorDependencies,
                tabDependencies: HomeTabDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
        self.tabDependencies = tabDependencies
    }
    
    public func start() {
//        showHomeViewController()
        showHomeViewControllerV1()
    }
    
    private func makeHomeTab(_ page: HomeTabBarPage) -> UIViewController {
        switch page {
        case .recommend:
            let flowAction = HomeRecommendFlowAction()
            return dependencies.makeHomeRecommendViewController(flowAction: flowAction)
            
        case .notice:
            let flowAction = HomeNoticeFlowAction()
            return dependencies.makeHomeNoticeViewController(flowAction: flowAction)
        }
    }
    
    private func makeHomeTabViewController() -> HomeTabViewController {
        let pages: [HomeTabBarPage] = [.recommend, .notice]
        let controllers: [UIViewController] = pages.map { makeHomeTab($0) }
        return dependencies.makeHomeTabViewController(tabViewControllers: controllers, tabTitles: pages.map { $0.title() }, isNewTabs: pages.map { $0.isNew() })
    }
    
    public func showHomeViewControllerV1() {
        let flowAction = HomeFlowAction(
            showNoticeDetailViewController: showNoticeDetailViewController,
            showSearchDetailViewController: showSearchDetailViewController,
            showSearchTab: tabDependencies.showSearchTab,
            showShapeSearchViewController: showShapeSearchViewController,
            showMyPageViewController: showMyPageViewController
        )
        let viewController = dependencies.makeHomeViewController(flowAction: flowAction, homeTabViewController: makeHomeTabViewController())
        navigationController?.pushViewController(viewController, animated: false)
    }
    
    public func showHomeViewController() {
        let flowAction = HomeFlowAction(
            showNoticeDetailViewController: showNoticeDetailViewController,
            showSearchDetailViewController: showSearchDetailViewController,
            showSearchTab: tabDependencies.showSearchTab,
            showShapeSearchViewController: showShapeSearchViewController,
            showMyPageViewController: showMyPageViewController
        )
        let viewController = dependencies.makeHomeViewController(flowAction: flowAction)
        navigationController?.pushViewController(viewController, animated: false)
        homeViewController = viewController
    }
    
    private func showNoticeDetailViewController(notice: NoticeModel) {
        let flowAction = NoticeDetailFlowAction(
            showNoticeDetailViewController: showNoticeDetailViewController,
            popViewController: popViewController,
            showSearchTab: tabDependencies.showSearchTab,
            showSearchShapeViewController: showShapeSearchViewController
        )
        let viewController = dependencies.makeNoticeDetailViewController(notice: notice, flowAction: flowAction)
        navigationController?.pushViewController(viewController, animated: true)
        noticeDetailViewController = viewController
    }
    
    private func showSearchDetailViewController(pillInfo: PillInfoModel) {
        let flowAction = SearchDetailFlowAction(
            popViewController: popViewController,
            showImageDetailViewController: showImageDetailViewController
        )
        let viewController = dependencies.makeSearchDetailViewController(pillInfo: pillInfo, flowAction: flowAction)
        navigationController?.pushViewController(viewController, animated: true)
        searchDetailViewController = viewController
    }
    
    private func showImageDetailViewController(pillName: String,
                                                className: String?,
                                                imageURL: URL) {
        let flowAction = ImageDetailFlowAction(dismiss: dismiss)
        let viewController = dependencies.makeImageDetailViewController(pillName: pillName, className: className, imageURL: imageURL, flowAction: flowAction)
        viewController.modalPresentationStyle = .overFullScreen
        navigationController?.present(viewController, animated: true)
        imageDetailViewController = viewController
    }
    
    private func dismiss(animated: Bool) {
        navigationController?.dismiss(animated: animated)
    }
    
    private func popViewController(animated: Bool) {
        navigationController?.popViewController(animated: animated)
    }
    
    private func showShapeSearchViewController() {
        tabDependencies.showShapeSearchViewController()
    }
    
    private func showMyPageViewController() {
        tabDependencies.showMyPageViewController()
    }
}
