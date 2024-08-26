//
//  DefaultSearchDetailRepository.swift
//  SearchData
//
//  Created by JunHyeok Lee on 8/12/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RxSwift

import NetworkInfra
import BaseDomain
import BaseData
import SearchDomain

public final class DefaultSearchDetailRepository: SearchDetailRepository {
    private let networkManager: NetworkManager
    private let hitHistoriesStorage: PillHitHistoryStorage
    
    public init(networkManager: NetworkManager,
                hitHistoriesStorage: PillHitHistoryStorage = DefaultPillHitHistoryStorage()) {
        self.networkManager = networkManager
        self.hitHistoriesStorage = hitHistoriesStorage
    }
}

extension DefaultSearchDetailRepository {
    public func executePillDescription(_ medicineSeq: Int) -> Single<PillDescription?> {
        return networkManager.requestPillDescription(medicineSeq).map { $0?.toDomain() }
    }
    
    public func executePillHits(medicineSeq: Int) -> Single<PillHits> {
        return networkManager.requestPillHits(medicineSeq).map { $0.toDomain() }
    }
    
    public func postPillHits(medicineSeq: Int, medicineName: String) -> Single<PillHits> {
        return networkManager.postPillHits(medicineSeq: medicineSeq, medicineName: medicineName).map { $0.toDomain() }
    }
    
    public func saveHitHistories(_ hitHistoreis: [Int]) -> [Int] {
        return hitHistoriesStorage.saveHitHistories(hitHistoreis)
    }
    
    public func loadHitHistories() -> [Int] {
        return hitHistoriesStorage.loadHitHistories()
    }
    
    public func deleteHitHistory(_ hit: Int) -> [Int] {
        return hitHistoriesStorage.deleteHitHistory(hit)
    }
    
    public func deleteAllHitHistories() {
        return hitHistoriesStorage.deleteAll()
    }
}
