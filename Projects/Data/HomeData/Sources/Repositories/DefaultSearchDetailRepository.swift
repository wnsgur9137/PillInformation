//
//  DefaultSearchDetailRepository.swift
//  HomeData
//
//  Created by JunHyeok Lee on 7/23/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RxSwift

import NetworkInfra
import BaseDomain
import HomeDomain

public final class DefaultSearchDetailRepository: SearchDetailRepository {
    private let networkManager: NetworkManager
    
    public init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
}

extension DefaultSearchDetailRepository {
    public func executePillDescription(_ medicineSeq: Int) -> Single<PillDescription?> {
        return networkManager.requestPillDescription(medicineSeq).map { $0?.toDomain() }
    }
}
