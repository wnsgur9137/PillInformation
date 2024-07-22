//
//  PillHitsResponseDTO+.swift
//  HomeData
//
//  Created by JunHyeok Lee on 7/22/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation

import BaseData
import BaseDomain

extension PillHitsResponseDTO {
    func toDomain() -> PillHits {
        return .init(medicineSeq: medicineSeq, medicineName: medicineName, hits: hits)
    }
}
