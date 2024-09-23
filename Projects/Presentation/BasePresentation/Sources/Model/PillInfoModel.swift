//
//  PillInfoModel.swift
//  BasePresentation
//
//  Created by JunHyeok Lee on 7/5/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RxDataSources

public struct PillInfoModel: IdentifiableType, Equatable {
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
    public var hits: Int
    public var identity: String
    
    public init(medicineSeq: Int, medicineName: String, entpSeq: Int, entpName: String, chart: String?, medicineImage: String, printFront: String?, printBack: String?, medicineShape: String, colorClass1: String?, colorClass2: String?, lineFront: String?, lineBack: String?, lengLong: Float?, lengShort: Float?, thick: Float?, imgRegistTs: Int, classNo: Int?, className: String?, etcOtcName: String, medicinePermitDate: Int, formCodeName: String?, markCodeFrontAnal: String?, markCodeBackAnal: String?, markCodeFrontImg: String?, markCodeBackImg: String?, changeDate: Int?, markCodeFront: String?, markCodeBack: String?, medicineEngName: String?, ediCode: Int?, hits: Int = 0) {
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
        self.hits = hits
        self.identity = UUID().uuidString
    }
}
