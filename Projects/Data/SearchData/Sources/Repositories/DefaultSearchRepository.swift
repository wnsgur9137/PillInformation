//
//  DefaultSearchRepository.swift
//  SearchData
//
//  Created by JunHyeok Lee on 2/27/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RxSwift

import NetworkInfra
import BaseDomain
import SearchDomain
import BaseData

public final class DefaultSearchRepository: SearchRepository {
    private let networkManager: NetworkManager
    private let hitHistoriesStorage: PillHitHistoryStorage
    private let disposeBag = DisposeBag()
    
    public init(networkManager: NetworkManager,
                hitHistoriesStorage: PillHitHistoryStorage = DefaultPillHitHistoryStorage()) {
        self.networkManager = networkManager
        self.hitHistoriesStorage = hitHistoriesStorage
    }
}

extension DefaultSearchRepository {
    public func executePill(keyword: String) -> Single<[PillInfo]> {
        return networkManager.requestPill(keyword: keyword).map { $0.map { $0.toDomain() } }
    }
    
    public func executePill(shapeInfo: PillShape) -> Single<[PillInfo]> {
        let shapeRequestDTO = SearchShapeRequestDTO.create(shapeInfo: shapeInfo)
        return networkManager.requestPill(shapeRequestDTO).map { $0.map { $0.toDomain() } }
    }
    
    public func executePillDescription(_ medicineSeq: Int) -> Single<PillDescription?> {
        return networkManager.requestPillDescription(medicineSeq).map { $0?.toDomain() }
    }
    
    public func executePillHits(medicineSeq: Int) -> Single<PillHits> {
        return networkManager.requestPillHits(medicineSeq).map { $0.toDomain() }
    }
    
    public func executeRecommendKeyword() -> Single<[String]> {
        return networkManager.requestRecommendKeyword()
    }
}
