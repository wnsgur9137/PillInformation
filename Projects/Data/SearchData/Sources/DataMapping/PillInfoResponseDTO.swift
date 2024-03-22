//
//  PillInfoResponseDTO.swift
//  SearchData
//
//  Created by JunHyeok Lee on 3/22/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation

public struct PillInfoResponseDTO: Decodable {
    let medicineSeq: String
    let medicineName: String
    let entpSeq: String
    let entpName: String
    let chart: String
    let medicineImage: String
    let printFront: String
    let printBack: String
    let medicineShape: String
    let colorClass1: String?
    let colorClass2: String?
    let lineFront: String?
    let lineBack: String?
    let lengLong: String
    let lengShort: String
    let thick: String
    let igRegistTs: String
    let classNo: String
    let className: String
    let etcOtcName: String
    let medicinePermitDate: String
    let formCodeName: String
    let markCodeFrontAnal: String
    let markCodeBackAnal: String
    let markCodeFrontImg: String
    let markCodeBackImg: String
    let changeDate: String
    let markCodeFront: String?
    let markCodeBack: String?
    let medicineEngName: String
    let ediCode: String?
}
