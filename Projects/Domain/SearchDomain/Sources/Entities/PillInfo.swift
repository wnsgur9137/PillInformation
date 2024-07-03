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
    public let medicineSeq: Int
    public let medicineName: String
    public let entpSeq: Int
    public let entpName: String
    public let chart: String?
    public let medicineImage: String
    public let printFront: String?
    public let printBack: String?
    public let medicineShape: String
    public let colorClass1: String?
    public let colorClass2: String?
    public let lineFront: String?
    public let lineBack: String?
    public let lengLong: Float?
    public let lengShort: Float?
    public let thick: Float?
    public let imgRegistTs: Int
    public let classNo: Int?
    public let className: String?
    public let etcOtcName: String
    public let medicinePermitDate: Int
    public let formCodeName: String?
    public let markCodeFrontAnal: String?
    public let markCodeBackAnal: String?
    public let markCodeFrontImg: String?
    public let markCodeBackImg: String?
    public let changeDate: Int?
    public let markCodeFront: String?
    public let markCodeBack: String?
    public let medicineEngName: String?
    public let ediCode: Int?
    
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
    
    public init(pillInfoModel: PillInfoModel) {
        self.medicineSeq = pillInfoModel.medicineSeq
        self.medicineName = pillInfoModel.medicineName
        self.entpSeq = pillInfoModel.entpSeq
        self.entpName = pillInfoModel.entpName
        self.chart = pillInfoModel.chart
        self.medicineImage = pillInfoModel.medicineImage
        self.printFront = pillInfoModel.printFront
        self.printBack = pillInfoModel.printBack
        self.medicineShape = pillInfoModel.medicineShape
        self.colorClass1 = pillInfoModel.colorClass1
        self.colorClass2 = pillInfoModel.colorClass2
        self.lineFront = pillInfoModel.lineFront
        self.lineBack = pillInfoModel.lineBack
        self.lengLong = pillInfoModel.lengLong
        self.lengShort = pillInfoModel.lengShort
        self.thick = pillInfoModel.thick
        self.imgRegistTs = pillInfoModel.imgRegistTs
        self.classNo = pillInfoModel.classNo
        self.className = pillInfoModel.className
        self.etcOtcName = pillInfoModel.etcOtcName
        self.medicinePermitDate = pillInfoModel.medicinePermitDate
        self.formCodeName = pillInfoModel.formCodeName
        self.markCodeFrontAnal = pillInfoModel.markCodeFrontAnal
        self.markCodeBackAnal = pillInfoModel.markCodeBackAnal
        self.markCodeFrontImg = pillInfoModel.markCodeFrontImg
        self.markCodeBackImg = pillInfoModel.markCodeBackImg
        self.changeDate = pillInfoModel.changeDate
        self.markCodeFront = pillInfoModel.markCodeFront
        self.markCodeBack = pillInfoModel.markCodeBack
        self.medicineEngName = pillInfoModel.medicineEngName
        self.ediCode = pillInfoModel.ediCode
    }
}

extension PillInfo {
    func toModel() -> PillInfoModel {
        return .init(medicineSeq: self.medicineSeq, medicineName: self.medicineName, entpSeq: self.entpSeq, entpName: self.entpName, chart: self.chart, medicineImage: self.medicineImage, printFront: self.printFront, printBack: self.printBack, medicineShape: self.medicineShape, colorClass1: self.colorClass1, colorClass2: self.colorClass2, lineFront: self.lineFront, lineBack: self.lineBack, lengLong: self.lengLong, lengShort: self.lengShort, thick: self.thick, imgRegistTs: self.imgRegistTs, classNo: self.classNo, className: self.className, etcOtcName: self.etcOtcName, medicinePermitDate: self.medicinePermitDate, formCodeName: self.formCodeName, markCodeFrontAnal: self.markCodeFrontAnal, markCodeBackAnal: self.markCodeBackAnal, markCodeFrontImg: self.markCodeFrontImg, markCodeBackImg: self.markCodeBackImg, changeDate: self.changeDate, markCodeFront: self.markCodeFront, markCodeBack: self.markCodeBack, medicineEngName: self.medicineEngName, ediCode: self.ediCode)
    }
}
