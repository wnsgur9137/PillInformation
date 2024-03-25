//
//  PillInfoModel.swift
//  SearchPresentation
//
//  Created by JunHyeok Lee on 3/25/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation

public struct PillInfoListModel {
    let resultCount: Int
    let medicineItem: [PillInfoModel]
    
    public init(resultCount: Int, medicineItem: [PillInfoModel]) {
        self.resultCount = resultCount
        self.medicineItem = medicineItem
    }
}

public struct PillInfoModel {
    let medicineSeq: String
    let medicineName: String
    let entpSeq: String
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
    let lengLong: String?
    let lengShort: String?
    let thick: String?
    let imgRegistTs: String
    let classNo: String?
    let className: String?
    let etcOtcName: String
    let medicinePermitDate: String
    let formCodeName: String?
    let markCodeFrontAnal: String?
    let markCodeBackAnal: String?
    let markCodeFrontImg: String?
    let markCodeBackImg: String?
    let changeDate: String?
    let markCodeFront: String?
    let markCodeBack: String?
    let medicineEngName: String?
    let ediCode: String?
    
    public init(medicineSeq: String, medicineName: String, entpSeq: String, entpName: String, chart: String?, medicineImage: String, printFront: String?, printBack: String?, medicineShape: String, colorClass1: String?, colorClass2: String?, lineFront: String?, lineBack: String?, lengLong: String?, lengShort: String?, thick: String?, imgRegistTs: String, classNo: String?, className: String?, etcOtcName: String, medicinePermitDate: String, formCodeName: String?, markCodeFrontAnal: String?, markCodeBackAnal: String?, markCodeFrontImg: String?, markCodeBackImg: String?, changeDate: String?, markCodeFront: String?, markCodeBack: String?, medicineEngName: String?, ediCode: String?) {
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
