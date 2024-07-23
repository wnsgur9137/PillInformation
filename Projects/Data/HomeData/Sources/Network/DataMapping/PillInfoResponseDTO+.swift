//
//  PillInfoResponseDTO.swift
//  HomeData
//
//  Created by JunHyeok Lee on 7/22/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation

import BaseData
import BaseDomain

extension PillInfoResponseDTO {
    static func create(pillInfo: PillInfo) -> PillInfoResponseDTO {
        return .init(medicineSeq: pillInfo.medicineSeq, medicineName: pillInfo.medicineName, entpSeq: pillInfo.entpSeq, entpName: pillInfo.entpName, chart: pillInfo.chart, medicineImage: pillInfo.medicineImage, printFront: pillInfo.printFront, printBack: pillInfo.printBack, medicineShape: pillInfo.medicineShape, colorClass1: pillInfo.colorClass1, colorClass2: pillInfo.colorClass2, lineFront: pillInfo.lineFront, lineBack: pillInfo.lineBack, lengLong: pillInfo.lengLong, lengShort: pillInfo.lengShort, thick: pillInfo.thick, imgRegistTs: pillInfo.imgRegistTs, classNo: pillInfo.classNo, className: pillInfo.className, etcOtcName: pillInfo.etcOtcName, medicinePermitDate: pillInfo.medicinePermitDate, formCodeName: pillInfo.formCodeName, markCodeFrontAnal: pillInfo.markCodeFrontAnal, markCodeBackAnal: pillInfo.markCodeBackAnal, markCodeFrontImg: pillInfo.markCodeFrontImg, markCodeBackImg: pillInfo.markCodeBackImg, changeDate: pillInfo.changeDate, markCodeFront: pillInfo.markCodeFront, markCodeBack: pillInfo.markCodeBack, medicineEngName: pillInfo.medicineEngName, ediCode: pillInfo.ediCode)
    }
    
    func toDomain() -> PillInfo {
        return .init(medicineSeq: self.medicineSeq, medicineName: self.medicineName, entpSeq: self.entpSeq, entpName: self.entpName, chart: self.chart, medicineImage: self.medicineImage, printFront: self.printFront, printBack: self.printBack, medicineShape: self.medicineShape, colorClass1: self.colorClass1, colorClass2: self.colorClass2, lineFront: self.lineFront, lineBack: self.lineBack, lengLong: self.lengLong, lengShort: self.lengShort, thick: self.thick, imgRegistTs: self.imgRegistTs, classNo: self.classNo, className: self.className, etcOtcName: self.etcOtcName, medicinePermitDate: self.medicinePermitDate, formCodeName: self.formCodeName, markCodeFrontAnal: self.markCodeFrontAnal, markCodeBackAnal: self.markCodeBackAnal, markCodeFrontImg: self.markCodeFrontImg, markCodeBackImg: self.markCodeBackImg, changeDate: self.changeDate, markCodeFront: self.markCodeFront, markCodeBack: self.markCodeBack, medicineEngName: self.medicineEngName, ediCode: self.ediCode)
    }
}
