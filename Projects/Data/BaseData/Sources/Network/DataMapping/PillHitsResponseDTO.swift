//
//  PillHitsResponseDTO.swift
//  BaseData
//
//  Created by JunHyeok Lee on 7/22/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation

public struct PillHitsResponseDTO: Decodable {
    public let medicineSeq: Int
    public let medicineName: String
    public let hits: Int
    
    enum CodingKeys: String, CodingKey {
        case medicineSeq = "medicine_seq"
        case medicineName = "medicine_name"
        case hits
    }
}
