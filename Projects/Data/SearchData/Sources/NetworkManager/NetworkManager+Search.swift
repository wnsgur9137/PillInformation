//
//  NetworkManager+Search.swift
//  SearchData
//
//  Created by JunHyeok Lee on 2/27/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RxSwift
import Moya

import NetworkInfra
import SearchDomain

extension NetworkManager {
    public func requestPill(keyword: String) -> Single<[PillInfoResponseDTO]> {
        return requestObject(.getPillList(name: keyword), type: [PillInfoResponseDTO].self)
    }
    
    public func requestPillDescription(_ medicineSeq: String) -> Single<PillDescriptionDTO?> {
        return requestObject(.getPillDescription(medicineSeq: medicineSeq), type: PillDescriptionDTO?.self)
    }
}
