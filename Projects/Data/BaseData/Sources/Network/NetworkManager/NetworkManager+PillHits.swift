//
//  NetworkManager+PillHits.swift
//  BaseData
//
//  Created by JunHyeok Lee on 8/12/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RxSwift
import Moya

import NetworkInfra

extension NetworkManager {
    public func requestPillHits(_ medicineSeq: Int) -> Single<PillHitsResponseDTO> {
        return requestObject(.getPillHits(medicineSeq: medicineSeq), type: PillHitsResponseDTO.self)
    }
    
    public func postPillHits(medicineSeq: Int, medicineName: String) -> Single<PillHitsResponseDTO> {
        return requestObject(.postPillHits(medicineSeq: medicineSeq, medicineName: medicineName), type: PillHitsResponseDTO.self)
    }
}
