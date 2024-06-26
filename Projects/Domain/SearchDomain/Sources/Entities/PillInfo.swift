//
//  PillInfo.swift
//  SearchDomain
//
//  Created by JunHyeok Lee on 3/25/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation

import SearchPresentation

public struct PillInfo {
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
}

extension PillInfo {
    func toModel() -> PillInfoModel {
        return .init(medicineSeq: self.medicineSeq, medicineName: self.medicineName, entpSeq: self.entpSeq, entpName: self.entpName, chart: self.chart, medicineImage: self.medicineImage, printFront: self.printFront, printBack: self.printBack, medicineShape: self.medicineShape, colorClass1: self.colorClass1, colorClass2: self.colorClass2, lineFront: self.lineFront, lineBack: self.lineBack, lengLong: self.lengLong, lengShort: self.lengShort, thick: self.thick, imgRegistTs: self.imgRegistTs, classNo: self.classNo, className: self.className, etcOtcName: self.etcOtcName, medicinePermitDate: self.medicinePermitDate, formCodeName: self.formCodeName, markCodeFrontAnal: self.markCodeFrontAnal, markCodeBackAnal: self.markCodeBackAnal, markCodeFrontImg: self.markCodeFrontImg, markCodeBackImg: self.markCodeBackImg, changeDate: self.changeDate, markCodeFront: self.markCodeFront, markCodeBack: self.markCodeBack, medicineEngName: self.medicineEngName, ediCode: self.ediCode)
    }
}
