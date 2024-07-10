//
//  PillHitsDTO.swift
//  SearchData
//
//  Created by JunHyeok Lee on 7/10/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation

import SearchDomain

public struct PillHitsDTO: Decodable {
    let medicineSeq: Int
    let medicineName: String
    let hits: Int
}

extension PillHitsDTO {
    func toDomain() -> PillHits {
        return .init(medicineSeq: medicineSeq, medicineName: medicineName, hits: hits)
    }
}
