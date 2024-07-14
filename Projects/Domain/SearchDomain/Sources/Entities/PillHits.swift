//
//  PillHits.swift
//  SearchDomain
//
//  Created by JunHyeok Lee on 7/10/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation

import SearchPresentation

public struct PillHits {
    let medicineSeq: Int
    let medicineName: String
    let hits: Int
    
    public init(medicineSeq: Int, medicineName: String, hits: Int) {
        self.medicineSeq = medicineSeq
        self.medicineName = medicineName
        self.hits = hits
    }
}

extension PillHits {
    func toModel() -> PillHitsModel {
        return .init(medicineSeq: medicineSeq, medicineName: medicineName, hits: hits)
    }
}
