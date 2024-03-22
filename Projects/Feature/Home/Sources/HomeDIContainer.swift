//
//  HomeDIContainer.swift
//  Home
//
//  Created by JunHyeok Lee on 3/21/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation

import NetworkInfra
import HomeData
import HomeDomain
import HomePresentation

public final class HomeDIContainer {
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

// MARK: - HomeCoordinatorDependencies
extension HomeDIContainer: HomeCoordinatorDependencies {
    // Notice
    public func makeNoticeRepository() -> NoticeRepository {
        return HomeData.DefaultNoticeRepository(networkManager: dependencies.networkManager)
    }
    public func makeNoticeUseCase() -> NoticeUseCase {
        return DefaultNoticeUseCase(with: makeNoticeRepository())
    }
    
    // Home
    public func makeHomeReactor(flowAction: HomeFlowAction) -> HomeReactor {
        return HomeReactor(with: makeNoticeUseCase(),
                                flowAction: flowAction)
    }
    public func makeHomeViewController(flowAction: HomeFlowAction) -> HomeViewController {
        return HomeViewController.create(with: makeHomeReactor(flowAction: flowAction))
    }
    
    // NoticeDetail
    public func makeNoticeDetailReactor(notice: NoticeModel,
                                 flowAction: NoticeDetailFlowAction) -> NoticeDetailReactor {
        return NoticeDetailReactor(notice: notice,
                                   noticeUseCase: makeNoticeUseCase(),
                                   flowAction: flowAction)
    }
    public func makeNoticeDetailViewController(notice: NoticeModel,
                                        flowAction: NoticeDetailFlowAction) -> NoticeDetailViewController {
        return NoticeDetailViewController.create(with: makeNoticeDetailReactor(notice: notice, flowAction: flowAction))
    }
}
