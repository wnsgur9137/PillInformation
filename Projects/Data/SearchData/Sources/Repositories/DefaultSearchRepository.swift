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
    public func executePill(keyword: String) -> Single<[PillInfo]> {
        return networkManager.requestPill(keyword: keyword).map { $0.map { $0.toDomain() } }
    }
    
    public func executePillDescription(_ medicineSeq: Int) -> Single<PillDescription?> {
        return networkManager.requestPillDescription(medicineSeq).map { $0?.toDomain() }
    }
}
