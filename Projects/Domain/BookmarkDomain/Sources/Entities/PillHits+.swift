//
//  PillHits+.swift
//  BookmarkDomain
//
//  Created by JunHyeok Lee on 8/12/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation

import BaseDomain
import BasePresentation

extension PillHits {
    func toModel() -> PillHitsModel {
        return .init(medicineSeq: medicineSeq, medicineName: medicineName, hits: hits)
    }
}
