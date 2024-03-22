//
//  MyPageDIContainer.swift
//  MyPage
//
//  Created by JunHyeok Lee on 3/21/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation

import NetworkInfra
import MyPageData
import MyPageDomain
import MyPagePresentation

public final class MyPageDIContainer {
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

// MARK: - MyPageCoordinatorDependencies
extension MyPageDIContainer: MyPageCoordinatorDependencies {
    public func makeMyPageViewController() -> MyPageViewController {
        return MyPageViewController()
    }
}
