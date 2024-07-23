//
//  NetworkManager+Home.swift
//  HomeData
//
//  Created by JunHyeok Lee on 2/19/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Moya

import NetworkInfra
import BaseData
import BaseDomain
import HomeDomain

extension NetworkManager {
    public func requestNotices() -> Single<[NoticeResponseDTO]> {
        return requestObject(.getAllNotices, type: [NoticeResponseDTO].self)
    }
    
    public func requestRecommnedPills() -> Single<[PillInfoResponseDTO]> {
        return requestObject(.getRecommendPills, type: [PillInfoResponseDTO].self)
    }
    
    public func updateHits(medicineSeq: Int, medicineName: String) -> Single<PillHitsResponseDTO> {
        return requestObject(.postPillHits(medicineSeq: medicineSeq, medicineName: medicineName), type: PillHitsResponseDTO.self)
    }
    
    public func requestPillDescription(_ medicineSeq: Int) -> Single<PillDescriptionResponseDTO?> {
        return requestObject(.getPillDescription(medicineSeq: medicineSeq), type: PillDescriptionResponseDTO?.self)
    }
}
