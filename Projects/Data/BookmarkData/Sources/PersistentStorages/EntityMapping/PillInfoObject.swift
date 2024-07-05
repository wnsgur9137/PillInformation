//
//  PillInfoObject.swift
//  BookmarkData
//
//  Created by JunHyeok Lee on 7/5/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RealmSwift

class PillInfoObject: Object {
    @Persisted(primaryKey: true) var medicineSeq: Int
    @Persisted var medicineName: String
    @Persisted var entpSeq: Int
    @Persisted var entpName: String
    @Persisted var chart: String?
    @Persisted var medicineImage: String
    @Persisted var printFront: String?
    @Persisted var printBack: String?
    @Persisted var medicineShape: String
    @Persisted var colorClass1: String?
    @Persisted var colorClass2: String?
    @Persisted var lineFront: String?
    @Persisted var lineBack: String?
    @Persisted var lengLong: Float?
    @Persisted var lengShort: Float?
    @Persisted var thick: Float?
    @Persisted var imgRegistTs: Int
    @Persisted var classNo: Int?
    @Persisted var className: String?
    @Persisted var etcOtcName: String
    @Persisted var medicinePermitDate: Int
    @Persisted var formCodeName: String?
    @Persisted var markCodeFrontAnal: String?
    @Persisted var markCodeBackAnal: String?
    @Persisted var markCodeFrontImg: String?
    @Persisted var markCodeBackImg: String?
    @Persisted var changeDate: Int?
    @Persisted var markCodeFront: String?
    @Persisted var markCodeBack: String?
    @Persisted var medicineEngName: String?
    @Persisted var ediCode: Int?
    
    convenience init(medicineSeq: Int, medicineName: String, entpSeq: Int, entpName: String, chart: String? = nil, medicineImage: String, printFront: String? = nil, printBack: String? = nil, medicineShape: String, colorClass1: String? = nil, colorClass2: String? = nil, lineFront: String? = nil, lineBack: String? = nil, lengLong: Float? = nil, lengShort: Float? = nil, thick: Float? = nil, imgRegistTs: Int, classNo: Int? = nil, className: String? = nil, etcOtcName: String, medicinePermitDate: Int, formCodeName: String? = nil, markCodeFrontAnal: String? = nil, markCodeBackAnal: String? = nil, markCodeFrontImg: String? = nil, markCodeBackImg: String? = nil, changeDate: Int? = nil, markCodeFront: String? = nil, markCodeBack: String? = nil, medicineEngName: String? = nil, ediCode: Int? = nil) {
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
    
    convenience init(pillInfoDTO: PillInfoResponseDTO) {
        self.init()
        self.medicineSeq = pillInfoDTO.medicineSeq
        self.medicineName = pillInfoDTO.medicineName
        self.entpSeq = pillInfoDTO.entpSeq
        self.entpName = pillInfoDTO.entpName
        self.chart = pillInfoDTO.chart
        self.medicineImage = pillInfoDTO.medicineImage
        self.printFront = pillInfoDTO.printFront
        self.printBack = pillInfoDTO.printBack
        self.medicineShape = pillInfoDTO.medicineShape
        self.colorClass1 = pillInfoDTO.colorClass1
        self.colorClass2 = pillInfoDTO.colorClass2
        self.lineFront = pillInfoDTO.lineFront
        self.lineBack = pillInfoDTO.lineBack
        self.lengLong = pillInfoDTO.lengLong
        self.lengShort = pillInfoDTO.lengShort
        self.thick = pillInfoDTO.thick
        self.imgRegistTs = pillInfoDTO.imgRegistTs
        self.classNo = pillInfoDTO.classNo
        self.className = pillInfoDTO.className
        self.etcOtcName = pillInfoDTO.etcOtcName
        self.medicinePermitDate = pillInfoDTO.medicinePermitDate
        self.formCodeName = pillInfoDTO.formCodeName
        self.markCodeFrontAnal = pillInfoDTO.markCodeFrontAnal
        self.markCodeBackAnal = pillInfoDTO.markCodeBackAnal
        self.markCodeFrontImg = pillInfoDTO.markCodeFrontImg
        self.markCodeBackImg = pillInfoDTO.markCodeBackImg
        self.changeDate = pillInfoDTO.changeDate
        self.markCodeFront = pillInfoDTO.markCodeFront
        self.markCodeBack = pillInfoDTO.markCodeBack
        self.medicineEngName = pillInfoDTO.medicineEngName
        self.ediCode = pillInfoDTO.ediCode
    }
}

extension PillInfoObject {
    func toDTO() -> PillInfoResponseDTO {
        return .init(medicineSeq: self.medicineSeq, medicineName: self.medicineName, entpSeq: self.entpSeq, entpName: self.entpName, chart: self.chart, medicineImage: self.medicineImage, printFront: self.printFront, printBack: self.printBack, medicineShape: self.medicineShape, colorClass1: self.colorClass1, colorClass2: self.colorClass2, lineFront: self.lineFront, lineBack: self.lineBack, lengLong: self.lengLong, lengShort: self.lengShort, thick: self.thick, imgRegistTs: self.imgRegistTs, classNo: self.classNo, className: self.className, etcOtcName: self.etcOtcName, medicinePermitDate: self.medicinePermitDate, formCodeName: self.formCodeName, markCodeFrontAnal: self.markCodeFrontAnal, markCodeBackAnal: self.markCodeBackAnal, markCodeFrontImg: self.markCodeFrontImg, markCodeBackImg: self.markCodeBackImg, changeDate: self.changeDate, markCodeFront: self.markCodeFront, markCodeBack: self.markCodeBack, medicineEngName: self.medicineEngName, ediCode: self.ediCode)
    }
}
