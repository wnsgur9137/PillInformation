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
    
    public func requestPillDescription(_ medicineSeq: Int) -> Single<PillDescriptionDTO?> {
        return requestObject(.getPillDescription(medicineSeq: medicineSeq), type: PillDescriptionDTO?.self)
    }
    
    public func requestRecommendPillNames() -> Single<[String]> {
        return requestObject(.getRecommendPillNames, type: [String].self)
    }
    
    public func requestPillHits(_ medicineSeq: Int) -> Single<PillHitsDTO> {
        return requestObject(.getPillHits(medicineSeq: medicineSeq), type: PillHitsDTO.self)
    }
    
    public func postPillHits(medicineSeq: Int, medicineName: String) -> Single<PillHitsDTO> {
        return requestObject(.postPillHits(medicineSeq: medicineSeq, medicineName: medicineName), type: PillHitsDTO.self)
    }
}
