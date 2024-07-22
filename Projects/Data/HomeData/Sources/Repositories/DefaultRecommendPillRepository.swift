//
//  DefaultRecommendPillRepository.swift
//  HomeData
//
//  Created by JunHyeok Lee on 7/22/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RxSwift

import NetworkInfra
import BaseData
import BaseDomain
import HomeDomain

public final class DefaultRecommendPillRepository: RecommendPillRepository {
    private let networkManager: NetworkManager
    
    public init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
}

extension DefaultRecommendPillRepository {
    public func executeRecommendPills() -> Single<[PillInfo]> {
        return networkManager.requestRecommnedPills().map { $0.map { $0.toDomain() } }
    }
    
    public func updatePillHits(medicineSeq: Int, medicineName: String) -> Single<PillHits> {
        return networkManager.updateHits(medicineSeq: medicineSeq, medicineName: medicineName).map { $0.toDomain() }
    }
}
