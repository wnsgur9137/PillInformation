//
//  HomeDIContainer.swift
//  Home
//
//  Created by JunHyeok Lee on 3/21/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit

import NetworkInfra
import HomeData
import HomeDomain
import HomePresentation
import BasePresentation

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
    private func makeNoticeRepository() -> NoticeRepository {
        return HomeData.DefaultNoticeRepository(networkManager: dependencies.networkManager)
    }
    private func makeNoticeUseCase() -> NoticeUseCase {
        return DefaultNoticeUseCase(with: makeNoticeRepository())
    }
    
    // Image detail
    private func makeImageDetailReactor(pillName: String, className: String?, imageURL: URL, flowAction: ImageDetailFlowAction) -> ImageDetailReactor {
        return ImageDetailReactor(pillName: pillName, className: className, imageURL: imageURL, flowAction: flowAction)
    }
    public func makeImageDetailViewController(pillName: String, className: String?, imageURL: URL, flowAction: ImageDetailFlowAction) -> ImageDetailViewController {
        return ImageDetailViewController.create(with: makeImageDetailReactor(pillName: pillName, className: className, imageURL: imageURL, flowAction: flowAction))
    }
    
    // Search detail
    private func makeSearchDetailRepository() -> SearchDetailRepository {
        return DefaultSearchDetailRepository(networkManager: dependencies.networkManager)
    }
    private func makeSearchDetailUseCase() -> SearchDetailUseCase {
        return DefaultSearchDetailUseCase(with: makeSearchDetailRepository())
    }
    private func makeSearchDetailReactor(pillInfo: PillInfoModel, flowAction: SearchDetailFlowAction) -> SearchDetailReactor {
        return SearchDetailReactor(with: makeSearchDetailUseCase(), pillInfo: pillInfo, flowAction: flowAction)
    }
    public func makeSearchDetailViewController(pillInfo: PillInfoModel, flowAction: SearchDetailFlowAction) -> any SearchDetailViewControllerProtocol {
        return DefaultSearchDetailViewController.create(with: makeSearchDetailReactor(pillInfo: pillInfo, flowAction: flowAction))
    }
    
    // Recommend Pills
    private func makeRecommendPillRepository() -> RecommendPillRepository {
        return DefaultRecommendPillRepository(networkManager: dependencies.networkManager)
    }
    private func makeRecommendPillUseCase() -> RecommendPillUseCase {
        return DefaultRecommendPillUseCase(with: makeRecommendPillRepository())
    }
    
    // Home
    private func makeHomeReactor(flowAction: HomeFlowAction) -> HomeReactor {
        return HomeReactor(noticeUseCase: makeNoticeUseCase(), recommendPillUseCase: makeRecommendPillUseCase(), flowAction: flowAction)
    }
    public func makeHomeViewController(flowAction: HomeFlowAction) -> HomeViewController {
        return HomeViewController.create(with: makeHomeReactor(flowAction: flowAction))
    }
    private func makeHomeRecommendReactor(flowAction: HomeRecommendFlowAction) -> HomeRecommendReactor {
        return HomeRecommendReactor(with: makeRecommendPillUseCase(), flowAction: flowAction)
    }
    public func makeHomeRecommendViewController(flowAction: HomeRecommendFlowAction) -> HomeRecommendViewController {
        return HomeRecommendViewController.create(with: makeHomeRecommendReactor(flowAction: flowAction))
    }
    private func makeHomeMapReactor(flowAction: HomeMapFlowAction) -> HomeMapReactor {
        return HomeMapReactor(flowAction: flowAction)
    }
    public func makeHomeMapViewController(flowAction: HomeMapFlowAction) -> HomeMapViewController {
        return HomeMapViewController.create(with: makeHomeMapReactor(flowAction: flowAction))
    }
    private func makeHomeNoticeReactor(flowAction: HomeNoticeFlowAction) -> HomeNoticeReactor {
        return HomeNoticeReactor(with: makeNoticeUseCase(), flowAction: flowAction)
    }
    public func makeHomeNoticeViewController(flowAction: HomeNoticeFlowAction) -> HomeNoticeViewController {
        return HomeNoticeViewController.create(with: makeHomeNoticeReactor(flowAction: flowAction))
    }
    public func makeHomeTabViewController(tabViewControllers: [UIViewController], tabTitles: [String], isNewTabs: [Bool]) -> HomeTabViewController {
        return HomeTabViewController.create(tabViewControllers: tabViewControllers, tabTitles: tabTitles, isNewTabs: isNewTabs)
    }
    public func makeHomeViewController(flowAction: HomeFlowAction, homeTabViewController: HomeTabViewController) -> HomeViewControllerV1 {
        return HomeViewControllerV1.create(with: makeHomeReactor(flowAction: flowAction), homeTabViewController: homeTabViewController)
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
