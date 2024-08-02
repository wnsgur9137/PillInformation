//
//  BookmarkDemoAppDIContainer.swift
//  BookmarkDemoApp
//
//  Created by JunHyeok Lee on 8/2/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation

import Bookmark
import NetworkInfra

final class BookmarkDemoAppDIContainer {
    private lazy var appConfiguration = BookmarkDemoAppConfiguration()
    
    private lazy var networkManager: NetworkManager = {
        return NetworkManager(
            withTest: false,
            withFail: false,
            baseURL: appConfiguration.apiBaseURL
        )
    }()
    
    func makeBookmarkDIContainer() -> BookmarkDIContainer {
        let dependencies = BookmarkDIContainer.Dependencies(networkManager: networkManager)
        return BookmarkDIContainer(dependencies: dependencies)
    }
}
