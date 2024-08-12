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
import BasePresentation
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
    
    private func makeBookmarkRepository() -> BookmarkDomain.BookmarkRepository {
        return DefaultBookmarkRepository()
    }
    private func makeBookmarkUseCase() -> BookmarkUseCase {
        return DefaultBookmarkUseCase(bookmarkRepository: makeBookmarkRepository())
    }
    private func makeBookmarkReactor(flowAction: BookmarkFlowAction) -> BookmarkReactor {
        return BookmarkReactor(
            bookmarkUseCase: makeBookmarkUseCase(),
            flowAction: flowAction
        )
    }
    public func makeBookmarkViewController(flowAction: BookmarkFlowAction) -> BookmarkViewController {
        return BookmarkViewController.create(with: makeBookmarkReactor(flowAction: flowAction))
    }
    
    private func makePillDetailRepository() -> SearchDetailRepository {
        return DefaultSearchDetailRepository(networkManager: dependencies.networkManager)
    }
    private func makeSearchDetailUseCase() -> SearchDetailUseCase {
        return DefaultSearchDetailUseCase(searchDetailRepository: makePillDetailRepository(), bookmarkRepository: makeBookmarkRepository())
    }
    private func makePillDetailReactor(pillInfo: PillInfoModel, flowAction: SearchDetailFlowAction) -> SearchDetailReactor {
        return SearchDetailReactor(with: makeSearchDetailUseCase(), pillInfo: pillInfo, flowAction: flowAction)
    }
    public func makePillDetailViewController(pillInfo: PillInfoModel, flowAction: SearchDetailFlowAction) -> SearchDetailViewController {
        return SearchDetailViewController.create(with: makePillDetailReactor(pillInfo: pillInfo, flowAction: flowAction))
    }
    
    private func makeImageDetailReactor(pillName: String, className: String?, imageURL: URL, flowAction: ImageDetailFlowAction) -> ImageDetailReactor {
        return ImageDetailReactor(pillName: pillName, className: className, imageURL: imageURL, flowAction: flowAction)
    }
    public func makeImageDetailViewController(pillName: String, className: String?, imageURL: URL, flowAction: ImageDetailFlowAction) -> ImageDetailViewController {
        return ImageDetailViewController.create(with: makeImageDetailReactor(pillName: pillName, className: className, imageURL: imageURL, flowAction: flowAction))
    }
}
