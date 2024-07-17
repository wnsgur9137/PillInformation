//
//  SearchCoordinator.swift
//  Search
//
//  Created by JunHyeok Lee on 1/30/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit

import SearchPresentation
import BasePresentation

public protocol SearchCoordinatorDependencies {
    func makeSearchViewController(flowAction: SearchFlowAction) -> SearchViewController
    func makeSearchResultViewController(keyword: String, flowAction: SearchResultFlowAction) -> SearchResultViewController
    func makeSearchResultViewController(shapeInfo: PillShapeModel, flowAction: SearchResultFlowAction) -> SearchResultViewController
    func makeSearchDetailViewController(pillInfo: PillInfoModel, flowAction: SearchDetailFlowAction) -> SearchDetailViewController
    func makeImageDetailViewController(pillName: String, className: String?, imageURL: URL, flowAction: ImageDetailFlowAction) -> ImageDetailViewController
    func makeSearchShapeViewController(flowAction: SearchShapeFlowAction) -> SearchShapeViewController
}

public protocol SearchTabDependencies {
    func showMyPageViewController()
}

public protocol SearchCoordinator: Coordinator {
    func showSearchViewController()
    func showSearchShapeViewController()
}

public final class DefaultSearchCoordinator: SearchCoordinator {
    public weak var finishDelegate: CoordinatorFinishDelegate?
    public weak var navigationController: UINavigationController?
    public var childCoordinators: [Coordinator] = []
    public var type: CoordinatorType { .search }
    
    private let dependencies: SearchCoordinatorDependencies
    private let tabDependencies: SearchTabDependencies?
    private weak var searchViewController: SearchViewController?
    private weak var searchResultViewController: SearchResultViewController?
    private weak var searchDetailViewController: SearchDetailViewController?
    private weak var imageDetailViewController: ImageDetailViewController?
    private weak var searchShapeViewController: SearchShapeViewController?
    
    public init(navigationController: UINavigationController,
                dependencies: SearchCoordinatorDependencies,
                tabDependencies: SearchTabDependencies?) {
        self.navigationController = navigationController
        self.dependencies = dependencies
        self.tabDependencies = tabDependencies
    }
    
    public func start() {
        showSearchViewController()
    }
    
    public func showSearchViewController() {
        let flowAction = SearchFlowAction(
            showSearchResultViewController: showSearchResultViewController,
            showMyPageViewController: showMyPageViewController,
            showSearchShapeViewController: showSearchShapeViewController
        )
        let viewController = dependencies.makeSearchViewController(flowAction: flowAction)
        navigationController?.pushViewController(viewController, animated: false)
        searchViewController = viewController
    }
    
    public func showSearchShapeViewController() {
        let flowAction = SearchShapeFlowAction(showSearchResultViewControler: showSearchResultViewController)
        let viewController = dependencies.makeSearchShapeViewController(flowAction: flowAction)
        navigationController?.pushViewController(viewController, animated: true)
        searchShapeViewController = viewController
    }
    
    private func showSearchResultViewController(keyword: String) {
        let flowAction = SearchResultFlowAction(
            popViewController: popViewController,
            showSearchDetailViewController: showSearchDetailViewController,
            showSearchShapeViewController: showSearchShapeViewController,
            showMyPageViewController: showMyPageViewController
        )
        let viewController = dependencies.makeSearchResultViewController(keyword: keyword, flowAction: flowAction)
        navigationController?.pushViewController(viewController, animated: true)
        searchResultViewController = viewController
    }
    
    private func showSearchResultViewController(shapeInfo: PillShapeModel) {
        let flowAction = SearchResultFlowAction(
            popViewController: popViewController,
            showSearchDetailViewController: showSearchDetailViewController,
            showSearchShapeViewController: showSearchShapeViewController,
            showMyPageViewController: showMyPageViewController
        )
        let viewController = dependencies.makeSearchResultViewController(shapeInfo: shapeInfo, flowAction: flowAction)
        navigationController?.pushViewController(viewController, animated: true)
        searchResultViewController = viewController
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
    
    private func showImageDetailViewController(pillInfo: (pillName: String, className: String?, imageURL: URL)) {
        let flowAction = ImageDetailFlowAction(
            dismiss: dismiss
        )
        let viewController = dependencies.makeImageDetailViewController(
            pillName: pillInfo.pillName,
            className: pillInfo.className,
            imageURL: pillInfo.imageURL,
            flowAction: flowAction
        )
        viewController.modalPresentationStyle = .overFullScreen
        navigationController?.present(viewController, animated: true)
        imageDetailViewController = viewController
    }
    
    private func popViewController(animated: Bool = true) {
        navigationController?.popViewController(animated: animated)
    }
    
    private func dismiss(animated: Bool = true) {
        navigationController?.dismiss(animated: animated)
    }
    
    private func showMyPageViewController() {
        tabDependencies?.showMyPageViewController()
    }
}
