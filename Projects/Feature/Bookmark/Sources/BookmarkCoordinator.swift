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
}

public protocol BookmarkCoordinator: Coordinator {
    
}

public final class DefaultBookmarkCoordinator: BookmarkCoordinator {
    public weak var finishDelegate: CoordinatorFinishDelegate?
    public var navigationController: UINavigationController?
    public var childCoordinators: [Coordinator] = []
    public var type: CoordinatorType { .bookmark }
    
    private let dependencies: BookmarkCoordinatorDependencies
    private weak var bookmarkViewController: BookmarkViewController?
    
    public init(navigationController: UINavigationController,
                dependencies: BookmarkCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    public func start() {
        showBookmarkViewController()
    }
    
    public func showBookmarkViewController() {
        let flowAction = BookmarkFlowAction()
        let viewController = dependencies.makeBookmarkViewController(flowAction: flowAction)
        navigationController?.pushViewController(viewController, animated: false)
        bookmarkViewController = viewController
    }
}
