//
//  PillInfoObject.swift
//  BaseData
//
//  Created by JunHyeok Lee on 7/5/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RealmSwift

public class PillInfoObject: Object {
    @Persisted(primaryKey: true) public var medicineSeq: Int
    @Persisted public var medicineName: String
    @Persisted public var entpSeq: Int
    @Persisted public var entpName: String
    @Persisted public var chart: String?
    @Persisted public var medicineImage: String
    @Persisted public var printFront: String?
    @Persisted public var printBack: String?
    @Persisted public var medicineShape: String
    @Persisted public var colorClass1: String?
    @Persisted public var colorClass2: String?
    @Persisted public var lineFront: String?
    @Persisted public var lineBack: String?
    @Persisted public var lengLong: Float?
    @Persisted public var lengShort: Float?
    @Persisted public var thick: Float?
    @Persisted public var imgRegistTs: Int
    @Persisted public var classNo: Int?
    @Persisted public var className: String?
    @Persisted public var etcOtcName: String
    @Persisted public var medicinePermitDate: Int
    @Persisted public var formCodeName: String?
    @Persisted public var markCodeFrontAnal: String?
    @Persisted public var markCodeBackAnal: String?
    @Persisted public var markCodeFrontImg: String?
    @Persisted public var markCodeBackImg: String?
    @Persisted public var changeDate: Int?
    @Persisted public var markCodeFront: String?
    @Persisted public var markCodeBack: String?
    @Persisted public var medicineEngName: String?
    @Persisted public var ediCode: Int?
    
    public convenience init(medicineSeq: Int, medicineName: String, entpSeq: Int, entpName: String, chart: String? = nil, medicineImage: String, printFront: String? = nil, printBack: String? = nil, medicineShape: String, colorClass1: String? = nil, colorClass2: String? = nil, lineFront: String? = nil, lineBack: String? = nil, lengLong: Float? = nil, lengShort: Float? = nil, thick: Float? = nil, imgRegistTs: Int, classNo: Int? = nil, className: String? = nil, etcOtcName: String, medicinePermitDate: Int, formCodeName: String? = nil, markCodeFrontAnal: String? = nil, markCodeBackAnal: String? = nil, markCodeFrontImg: String? = nil, markCodeBackImg: String? = nil, changeDate: Int? = nil, markCodeFront: String? = nil, markCodeBack: String? = nil, medicineEngName: String? = nil, ediCode: Int? = nil) {
        self.init()
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

extension PillInfoObject {
    static func makePillInfoObject(_ pillInfoDTO: PillInfoResponseDTO) -> PillInfoObject {
        return .init(medicineSeq: pillInfoDTO.medicineSeq, medicineName: pillInfoDTO.medicineName, entpSeq: pillInfoDTO.entpSeq, entpName: pillInfoDTO.entpName, chart: pillInfoDTO.chart, medicineImage: pillInfoDTO.medicineImage, printFront: pillInfoDTO.printFront, printBack: pillInfoDTO.printBack, medicineShape: pillInfoDTO.medicineShape, colorClass1: pillInfoDTO.colorClass1, colorClass2: pillInfoDTO.colorClass2, lineFront: pillInfoDTO.lineFront, lineBack: pillInfoDTO.lineBack, lengLong: pillInfoDTO.lengLong, lengShort: pillInfoDTO.lengShort, thick: pillInfoDTO.thick, imgRegistTs: pillInfoDTO.imgRegistTs, classNo: pillInfoDTO.classNo, className: pillInfoDTO.className, etcOtcName: pillInfoDTO.etcOtcName, medicinePermitDate: pillInfoDTO.medicinePermitDate, formCodeName: pillInfoDTO.formCodeName, markCodeFrontAnal: pillInfoDTO.markCodeFrontAnal, markCodeBackAnal: pillInfoDTO.markCodeBackAnal, markCodeFrontImg: pillInfoDTO.markCodeFrontImg, markCodeBackImg: pillInfoDTO.markCodeBackImg, changeDate: pillInfoDTO.changeDate, markCodeFront: pillInfoDTO.markCodeFront, markCodeBack: pillInfoDTO.markCodeBack, medicineEngName: pillInfoDTO.medicineEngName, ediCode: pillInfoDTO.ediCode)
    }
}

extension PillInfoObject {
    func toDTO() -> PillInfoResponseDTO {
        return .init(medicineSeq: self.medicineSeq, medicineName: self.medicineName, entpSeq: self.entpSeq, entpName: self.entpName, chart: self.chart, medicineImage: self.medicineImage, printFront: self.printFront, printBack: self.printBack, medicineShape: self.medicineShape, colorClass1: self.colorClass1, colorClass2: self.colorClass2, lineFront: self.lineFront, lineBack: self.lineBack, lengLong: self.lengLong, lengShort: self.lengShort, thick: self.thick, imgRegistTs: self.imgRegistTs, classNo: self.classNo, className: self.className, etcOtcName: self.etcOtcName, medicinePermitDate: self.medicinePermitDate, formCodeName: self.formCodeName, markCodeFrontAnal: self.markCodeFrontAnal, markCodeBackAnal: self.markCodeBackAnal, markCodeFrontImg: self.markCodeFrontImg, markCodeBackImg: self.markCodeBackImg, changeDate: self.changeDate, markCodeFront: self.markCodeFront, markCodeBack: self.markCodeBack, medicineEngName: self.medicineEngName, ediCode: self.ediCode)
    }
}
