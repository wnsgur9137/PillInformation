//
//  PillHitsResponseDTO.swift
//  SearchData
//
//  Created by JunHyeok Lee on 7/10/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation

import SearchDomain

public struct PillHitsResponseDTO: Decodable {
    let medicineSeq: Int
    let medicineName: String
    let hits: Int
    
    enum CodingKeys: String, CodingKey {
        case medicineSeq = "medicine_seq"
        case medicineName = "medicine_name"
        case hits
    }
}

extension PillHitsResponseDTO {
    func toDomain() -> PillHits {
        return .init(medicineSeq: medicineSeq, medicineName: medicineName, hits: hits)
    }
}
