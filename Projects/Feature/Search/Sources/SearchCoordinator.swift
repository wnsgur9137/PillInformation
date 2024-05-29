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
    func makeSearchDetailViewController(pillInfo: PillInfoModel, flowAction: SearchDetailFlowAction) -> SearchDetailViewController
    func makeImageDetailViewController(pillName: String, className: String?, imageURL: URL, flowAction: ImageDetailFlowAction) -> ImageDetailViewController
}

public protocol SearchTabDependencies {
    func showMyPage()
}

public protocol SearchCoordinator: Coordinator {
    func showSearchViewController()
}

public final class DefaultSearchCoordinator: SearchCoordinator {
    public weak var finishDelegate: CoordinatorFinishDelegate?
    public weak var navigationController: UINavigationController?
    public var childCoordinators: [Coordinator] = []
    public var type: CoordinatorType { .search }
    
    private let dependencies: SearchCoordinatorDependencies
    private let tabDependencies: SearchTabDependencies
    private weak var searchViewController: SearchViewController?
    private weak var searchResultViewController: SearchResultViewController?
    private weak var searchDetailViewController: SearchDetailViewController?
    private weak var imageDetailViewController: ImageDetailViewController?
    
    public init(navigationController: UINavigationController,
                dependencies: SearchCoordinatorDependencies,
                tabDependencies: SearchTabDependencies) {
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
            showMyPage: showMyPage
        )
        let viewController = dependencies.makeSearchViewController(flowAction: flowAction)
        navigationController?.pushViewController(viewController, animated: false)
        searchViewController = viewController
    }
    
    private func showSearchResultViewController(keyword: String) {
        let flowAction = SearchResultFlowAction(
            popViewController: popViewController,
            showSearchDetailViewController: showSearchDetailViewController,
            showMyPage: showMyPage
        )
        let viewController = dependencies.makeSearchResultViewController(keyword: keyword, flowAction: flowAction)
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
    
    private func showMyPage() {
        tabDependencies.showMyPage()
    }
}
