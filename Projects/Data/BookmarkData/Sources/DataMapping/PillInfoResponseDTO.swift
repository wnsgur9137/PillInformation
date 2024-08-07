//
//  PillInfoResponseDTO.swift
//  BookmarkData
//
//  Created by JunHyeok Lee on 7/5/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation

import BaseDomain

public struct PillInfoResponseDTO: Decodable {
    let medicineSeq: Int
    let medicineName: String
    let entpSeq: Int
    let entpName: String
    let chart: String?
    let medicineImage: String
    let printFront: String?
    let printBack: String?
    let medicineShape: String
    let colorClass1: String?
    let colorClass2: String?
    let lineFront: String?
    let lineBack: String?
    let lengLong: Float?
    let lengShort: Float?
    let thick: Float?
    let imgRegistTs: Int
    let classNo: Int?
    let className: String?
    let etcOtcName: String
    let medicinePermitDate: Int
    let formCodeName: String?
    let markCodeFrontAnal: String?
    let markCodeBackAnal: String?
    let markCodeFrontImg: String?
    let markCodeBackImg: String?
    let changeDate: Int?
    let markCodeFront: String?
    let markCodeBack: String?
    let medicineEngName: String?
    let ediCode: Int?
    
    public init(medicineSeq: Int, medicineName: String, entpSeq: Int, entpName: String, chart: String?, medicineImage: String, printFront: String?, printBack: String?, medicineShape: String, colorClass1: String?, colorClass2: String?, lineFront: String?, lineBack: String?, lengLong: Float?, lengShort: Float?, thick: Float?, imgRegistTs: Int, classNo: Int?, className: String?, etcOtcName: String, medicinePermitDate: Int, formCodeName: String?, markCodeFrontAnal: String?, markCodeBackAnal: String?, markCodeFrontImg: String?, markCodeBackImg: String?, changeDate: Int?, markCodeFront: String?, markCodeBack: String?, medicineEngName: String?, ediCode: Int?) {
        self.medicineSeq = medicineSeq
        self.medicineName = medicineName
        self.entpSeq = entpSeq
        self.entpName = entpName
        self.chart = chart
        self.medicineImage = medicineImage
        self.printFront = printFront
        self.printBack = printBack
        self.medicineShape = medicineShape
        self.colorClass1 = colorClass1
        self.colorClass2 = colorClass2
        self.lineFront = lineFront
        self.lineBack = lineBack
        self.lengLong = lengLong
        self.lengShort = lengShort
        self.thick = thick
        self.imgRegistTs = imgRegistTs
        self.classNo = classNo
        self.className = className
        self.etcOtcName = etcOtcName
        self.medicinePermitDate = medicinePermitDate
        self.formCodeName = formCodeName
        self.markCodeFrontAnal = markCodeFrontAnal
        self.markCodeBackAnal = markCodeBackAnal
        self.markCodeFrontImg = markCodeFrontImg
        self.markCodeBackImg = markCodeBackImg
        self.changeDate = changeDate
        self.markCodeFront = markCodeFront
        self.markCodeBack = markCodeBack
        self.medicineEngName = medicineEngName
        self.ediCode = ediCode
    }
    
    public init(pillInfo: PillInfo) {
        self.medicineSeq = pillInfo.medicineSeq
        self.medicineName = pillInfo.medicineName
        self.entpSeq = pillInfo.entpSeq
        self.entpName = pillInfo.entpName
        self.chart = pillInfo.chart
        self.medicineImage = pillInfo.medicineImage
        self.printFront = pillInfo.printFront
        self.printBack = pillInfo.printBack
        self.medicineShape = pillInfo.medicineShape
        self.colorClass1 = pillInfo.colorClass1
        self.colorClass2 = pillInfo.colorClass2
        self.lineFront = pillInfo.lineFront
        self.lineBack = pillInfo.lineBack
        self.lengLong = pillInfo.lengLong
        self.lengShort = pillInfo.lengShort
        self.thick = pillInfo.thick
        self.imgRegistTs = pillInfo.imgRegistTs
        self.classNo = pillInfo.classNo
        self.className = pillInfo.className
        self.etcOtcName = pillInfo.etcOtcName
        self.medicinePermitDate = pillInfo.medicinePermitDate
        self.formCodeName = pillInfo.formCodeName
        self.markCodeFrontAnal = pillInfo.markCodeFrontAnal
        self.markCodeBackAnal = pillInfo.markCodeBackAnal
        self.markCodeFrontImg = pillInfo.markCodeFrontImg
        self.markCodeBackImg = pillInfo.markCodeBackImg
        self.changeDate = pillInfo.changeDate
        self.markCodeFront = pillInfo.markCodeFront
        self.markCodeBack = pillInfo.markCodeBack
        self.medicineEngName = pillInfo.medicineEngName
        self.ediCode = pillInfo.ediCode
    }
}

extension PillInfoResponseDTO {
    func toDomain() -> PillInfo {
        return .init(medicineSeq: self.medicineSeq, medicineName: self.medicineName, entpSeq: self.entpSeq, entpName: self.entpName, chart: self.chart, medicineImage: self.medicineImage, printFront: self.printFront, printBack: self.printBack, medicineShape: self.medicineShape, colorClass1: self.colorClass1, colorClass2: self.colorClass2, lineFront: self.lineFront, lineBack: self.lineBack, lengLong: self.lengLong, lengShort: self.lengShort, thick: self.thick, imgRegistTs: self.imgRegistTs, classNo: self.classNo, className: self.className, etcOtcName: self.etcOtcName, medicinePermitDate: self.medicinePermitDate, formCodeName: self.formCodeName, markCodeFrontAnal: self.markCodeFrontAnal, markCodeBackAnal: self.markCodeBackAnal, markCodeFrontImg: self.markCodeFrontImg, markCodeBackImg: self.markCodeBackImg, changeDate: self.changeDate, markCodeFront: self.markCodeFront, markCodeBack: self.markCodeBack, medicineEngName: self.medicineEngName, ediCode: self.ediCode)
    }
}
