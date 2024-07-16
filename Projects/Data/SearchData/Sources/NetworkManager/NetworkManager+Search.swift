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
    
    public func requestPill(_ shapeInfo: SearchShapeRequestDTO) -> Single<[PillInfoResponseDTO]> {
        return requestObject(.getPillShapeList(
            shapes: shapeInfo.shapes,
            colors: shapeInfo.colors,
            lines: shapeInfo.lines,
            codes: shapeInfo.codes
        ), type: [PillInfoResponseDTO].self)
    }
    
    public func requestPillDescription(_ medicineSeq: Int) -> Single<PillDescriptionResponseDTO?> {
        return requestObject(.getPillDescription(medicineSeq: medicineSeq), type: PillDescriptionResponseDTO?.self)
    }
    
    public func requestRecommendPillNames() -> Single<[String]> {
        return requestObject(.getRecommendPillNames, type: [String].self)
    }
    
    public func requestPillHits(_ medicineSeq: Int) -> Single<PillHitsResponseDTO> {
        return requestObject(.getPillHits(medicineSeq: medicineSeq), type: PillHitsResponseDTO.self)
    }
    
    public func postPillHits(medicineSeq: Int, medicineName: String) -> Single<PillHitsResponseDTO> {
        return requestObject(.postPillHits(medicineSeq: medicineSeq, medicineName: medicineName), type: PillHitsResponseDTO.self)
    }
    
    public func requestRecommendKeyword() -> Single<[String]> {
        return requestObject(.getRecommendKeyword, type: [String].self)
    }
}
