//
//  BookmarkDIContainer.swift
//  Bookmark
//
//  Created by JunHyeok Lee on 4/18/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation

import NetworkInfra
import BookmarkData
import BookmarkDomain
import BookmarkPresentation

public final class BookmarkDIContainer {
    public struct Dependencies {
        let networkManager: NetworkManager
        
        public init(networkManager: NetworkManager) {
            self.networkManager = networkManager
        }
    }
    
    let dependencies: Dependencies
    
    public init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
}

// MARK: - BookmarkCoordinatorDependencies
extension BookmarkDIContainer: BookmarkCoordinatorDependencies {
    
    private func makeBookmarkRepository() -> BookmarkRepository {
        return DefaultBookmarkRepository()
    }
    private func makeBookmarkUseCase() -> BookmarkUseCase {
        return DefaultBookmarkUseCase(bookmarkRepository: makeBookmarkRepository())
    }
    public func makeBookmarkReactor(flowAction: BookmarkFlowAction) -> BookmarkReactor {
        return BookmarkReactor(
            bookmarkUseCase: makeBookmarkUseCase(),
            flowAction: flowAction
        )
    }
    
    public func makeBookmarkViewController(flowAction: BookmarkFlowAction) -> BookmarkViewController {
        return BookmarkViewController.create(with: makeBookmarkReactor(flowAction: flowAction))
    }
}
