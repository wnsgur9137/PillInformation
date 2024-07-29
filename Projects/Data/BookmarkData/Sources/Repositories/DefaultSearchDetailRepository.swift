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
import BaseDomain
import BookmarkDomain

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
