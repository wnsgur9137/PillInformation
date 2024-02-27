//
//  DefaultSearchRepository.swift
//  SearchData
//
//  Created by JunHyeok Lee on 2/27/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RxSwift

import SearchDomain
import NetworkInfra

public final class DefaultSearchRepository: SearchRepository {
    private let networkManager: NetworkManager
    private let disposeBag = DisposeBag()
    
    public init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
}

extension DefaultSearchRepository {
    public func executePill(keyword: String) -> RxSwift.Single<[String]> {
        return networkManager.requestPill(keyword: keyword)
    }
}
