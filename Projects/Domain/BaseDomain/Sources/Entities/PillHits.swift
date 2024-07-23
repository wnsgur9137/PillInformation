//
//  PillHits.swift
//  BaseDomain
//
//  Created by JunHyeok Lee on 7/22/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation

public struct PillHits {
    public let medicineSeq: Int
    public let medicineName: String
    public let hits: Int
    
    public init(medicineSeq: Int, medicineName: String, hits: Int) {
        self.medicineSeq = medicineSeq
        self.medicineName = medicineName
        self.hits = hits
    }
}
