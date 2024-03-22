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
    public func makeSearchRepository() -> SearchRepository {
        return DefaultSearchRepository(networkManager: dependencies.networkManager)
    }
    public func makeSearchUseCase() -> SearchUseCase {
        return DefaultSearchUseCase(with: makeSearchRepository())
    }
    public func makeSearchReactor(flowAction: SearchFlowAction) -> SearchReactor {
        return SearchReactor(with: makeSearchUseCase(), flowAction: flowAction)
    }
    public func makeSearchViewController(flowAction: SearchFlowAction) -> SearchViewController {
        return SearchViewController().create(with: makeSearchReactor(flowAction: flowAction))
    }
}
