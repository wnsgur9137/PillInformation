//
//  SearchDIContainer.swift
//  Search
//
//  Created by JunHyeok Lee on 3/21/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation

import NetworkInfra
import SearchData
import SearchDomain
import SearchPresentation

public final class SearchDIContainer {
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

// MARK: - SearchCoordinatorDependencies
extension SearchDIContainer: SearchCoordinatorDependencies {
    private func makeSearchRepository() -> SearchRepository {
        return DefaultSearchRepository(networkManager: dependencies.networkManager)
    }
    private func makeSearchUseCase() -> SearchUseCase {
        return DefaultSearchUseCase(with: makeSearchRepository())
    }
    
    private func makeSearchReactor(flowAction: SearchFlowAction) -> SearchReactor {
        return SearchReactor(flowAction: flowAction)
    }
    public func makeSearchViewController(flowAction: SearchFlowAction) -> SearchViewController {
        return SearchViewController().create(with: makeSearchReactor(flowAction: flowAction))
    }
    
    private func makeSearchResultReactor(keyword: String, flowAction: SearchResultFlowAction) -> SearchResultReactor {
        return SearchResultReactor(with: makeSearchUseCase(), keyword: keyword, flowAction: flowAction)
    }
    public func makeSearchResultViewController(keyword: String, flowAction: SearchResultFlowAction) -> SearchResultViewController {
        return SearchResultViewController.create(with: makeSearchResultReactor(keyword: keyword, flowAction: flowAction))
    }
}
