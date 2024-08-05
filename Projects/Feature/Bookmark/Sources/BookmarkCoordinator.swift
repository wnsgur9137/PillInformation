//
//  BookmarkCoordinator.swift
//  Bookmark
//
//  Created by JunHyeok Lee on 4/18/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit

import BookmarkPresentation
import BasePresentation

public protocol BookmarkCoordinatorDependencies {
    func makeBookmarkViewController(flowAction: BookmarkFlowAction) -> BookmarkViewController
    func makePillDetailViewController(pillInfo: PillInfoModel, flowAction: SearchDetailFlowAction) -> SearchDetailViewControllerProtocol
    func makeImageDetailViewController(pillName: String, className: String?, imageURL: URL, flowAction: ImageDetailFlowAction) -> ImageDetailViewController
}

public protocol BookmarkTabDependencies {
    func showMyPageViewController()
    func showShapeSearchViewController()
}

public protocol BookmarkCoordinator: Coordinator {
    
}

public final class DefaultBookmarkCoordinator: BookmarkCoordinator {
    public weak var finishDelegate: CoordinatorFinishDelegate?
    public var navigationController: UINavigationController?
    public var childCoordinators: [Coordinator] = []
    public var type: CoordinatorType { .bookmark }
    
    private let dependencies: BookmarkCoordinatorDependencies
    private let tabDependencies: BookmarkTabDependencies?
    private weak var bookmarkViewController: BookmarkViewController?
    private weak var pillDetailViewController: SearchDetailViewControllerProtocol?
    private weak var imageDetailViewController: ImageDetailViewController?
    
    public init(navigationController: UINavigationController,
                dependencies: BookmarkCoordinatorDependencies,
                tabDependencies: BookmarkTabDependencies?) {
        self.navigationController = navigationController
        self.dependencies = dependencies
        self.tabDependencies = tabDependencies
    }
    
    public func start() {
        showBookmarkViewController()
    }
    
    public func showBookmarkViewController() {
        let flowAction = BookmarkFlowAction(
            showSearchShapeViewController: showSearchShapeViewController,
            showPillDetailViewController: showPillDetailViewController,
            showMyPageViewController: showMyPageViewController
        )
        let viewController = dependencies.makeBookmarkViewController(flowAction: flowAction)
        navigationController?.pushViewController(viewController, animated: false)
        bookmarkViewController = viewController
    }
    
    private func showSearchShapeViewController() {
        tabDependencies?.showShapeSearchViewController()
    }
    
    private func showPillDetailViewController(pillInfo: PillInfoModel) {
        let flowAction = SearchDetailFlowAction(
            popViewController: popViewController,
            showImageDetailViewController: showImageDetailViewController
        )
        let viewController = dependencies.makePillDetailViewController(pillInfo: pillInfo, flowAction: flowAction)
        navigationController?.pushViewController(viewController, animated: true)
        pillDetailViewController = viewController
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
    
    public func showMyPageViewController() {
        tabDependencies?.showMyPageViewController()
    }
    
    private func popViewController(animated: Bool) {
        navigationController?.popViewController(animated: animated)
    }
    
    private func dismiss(animated: Bool) {
        navigationController?.dismiss(animated: animated)
    }
}
