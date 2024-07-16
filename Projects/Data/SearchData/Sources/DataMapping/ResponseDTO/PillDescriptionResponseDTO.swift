//
//  PillDescriptionResponseDTO.swift
//  SearchData
//
//  Created by JunHyeok Lee on 5/24/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation

import BaseDomain

public struct PillDescriptionResponseDTO: Decodable {
    let medicineSeq: Int
    let medicineName: String
    let entpName: String
    let efcyQestim: String?
    let useMethodQesitm: String?
    let atpnWarnQesitm: String?
    let atpnQesitm: String?
    let intrcQesitm: String?
    let seQesitm: String?
    let depositMethodQesitm: String?
    
    enum CodingKeys: String, CodingKey {
        case medicineSeq = "drugSeq"
        case medicineName = "drugName"
        case entpName
        case efcyQestim
        case useMethodQesitm
        case atpnWarnQesitm
        case atpnQesitm
        case intrcQesitm
        case seQesitm
        case depositMethodQesitm
    }
}

extension PillDescriptionResponseDTO {
    func toDomain() -> PillDescription {
        return .init(medicineSeq: self.medicineSeq, medicineName: self.medicineName, entpName: self.entpName, efcyQestim: self.efcyQestim, useMethodQesitm: self.useMethodQesitm, atpnWarnQesitm: self.atpnWarnQesitm, atpnQesitm: self.atpnQesitm, intrcQesitm: self.intrcQesitm, seQesitm: self.seQesitm, depositMethodQesitm: self.depositMethodQesitm)
    }
}
