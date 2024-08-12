//
//  DefaultSearchDetailRepository.swift
//  BookmarkData
//
//  Created by JunHyeok Lee on 7/25/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RxSwift

import NetworkInfra
import BaseData
import BaseDomain
import BookmarkDomain

public final class DefaultSearchDetailRepository: SearchDetailRepository {
    private let networkManager: NetworkManager
    private let hitHistoryStorage: PillHitHistoryStorage
    
    public init(networkManager: NetworkManager,
                hitHistoryStorage: PillHitHistoryStorage = DefaultPillHitHistoryStorage()) {
        self.networkManager = networkManager
        self.hitHistoryStorage = hitHistoryStorage
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
    
    public func saveHitHistories(_ hitHistoreis: [Int]) {
        return hitHistoryStorage.saveHitHistories(hitHistoreis)
    }
    
    public func loadHitHistories() -> [Int] {
        return hitHistoryStorage.loadHitHistories()
    }
}
