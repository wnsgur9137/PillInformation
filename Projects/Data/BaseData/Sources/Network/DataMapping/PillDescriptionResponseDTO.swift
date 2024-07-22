//
//  PillDescriptionResponseDTO.swift
//  BaseData
//
//  Created by JunHyeok Lee on 7/22/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation

public struct PillDescriptionResponseDTO: Decodable {
    public let medicineSeq: Int
    public let medicineName: String
    public let entpName: String
    public let efcyQestim: String?
    public let useMethodQesitm: String?
    public let atpnWarnQesitm: String?
    public let atpnQesitm: String?
    public let intrcQesitm: String?
    public let seQesitm: String?
    public let depositMethodQesitm: String?
    
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
