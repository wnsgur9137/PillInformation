//
//  PillDescriptionDTO.swift
//  SearchData
//
//  Created by JunHyeok Lee on 5/24/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation

import SearchDomain

public struct PillDescriptionDTO: Decodable {
    let medicineSeq: String
    let medicineName: String
    let entpName: String
    let efcyQestim: String?
    let useMethodQesitm: String?
    let atpnWarnQesitm: String?
    let intrcQesitm: String?
    let seQesitm: String?
    let depositMethodQesitm: String?
    
    enum CodingKeys: String, CodingKey {
        case medicineSeq
        case medicineName
        case entpName
        case efcyQestim
        case useMethodQesitm
        case atpnWarnQesitm
        case intrcQesitm
        case seQesitm
        case depositMethodQesitm
    }
}

extension PillDescriptionDTO {
    func toDomain() -> PillDescription {
        return .init(medicineSeq: self.medicineSeq, medicineName: self.medicineName, entpName: self.entpName, efcyQestim: self.efcyQestim, useMethodQesitm: self.useMethodQesitm, atpnWarnQesitm: self.atpnWarnQesitm, intrcQesitm: self.intrcQesitm, seQesitm: self.seQesitm, depositMethodQesitm: self.depositMethodQesitm)
    }
}
