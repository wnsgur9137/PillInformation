//
//  PillInfo.swift
//  SearchDomain
//
//  Created by JunHyeok Lee on 7/5/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation

import BaseDomain
import BasePresentation

extension PillInfo {
    static func makePillInfo(_ pillInfoModel: PillInfoModel) -> PillInfo {
        return PillInfo(medicineSeq: pillInfoModel.medicineSeq, medicineName: pillInfoModel.medicineName, entpSeq: pillInfoModel.entpSeq, entpName: pillInfoModel.entpName, chart: pillInfoModel.chart, medicineImage: pillInfoModel.medicineImage, printFront: pillInfoModel.printFront, printBack: pillInfoModel.printBack, medicineShape: pillInfoModel.medicineShape, colorClass1: pillInfoModel.colorClass1, colorClass2: pillInfoModel.colorClass2, lineFront: pillInfoModel.lineFront, lineBack: pillInfoModel.lineBack, lengLong: pillInfoModel.lengLong, lengShort: pillInfoModel.lengShort, thick: pillInfoModel.thick, imgRegistTs: pillInfoModel.imgRegistTs, classNo: pillInfoModel.classNo, className: pillInfoModel.className, etcOtcName: pillInfoModel.etcOtcName, medicinePermitDate: pillInfoModel.medicinePermitDate, formCodeName: pillInfoModel.formCodeName, markCodeFrontAnal: pillInfoModel.markCodeFrontAnal, markCodeBackAnal: pillInfoModel.markCodeBackAnal, markCodeFrontImg: pillInfoModel.markCodeFrontImg, markCodeBackImg: pillInfoModel.markCodeBackImg, changeDate: pillInfoModel.changeDate, markCodeFront: pillInfoModel.markCodeFront, markCodeBack: pillInfoModel.markCodeBack, medicineEngName: pillInfoModel.medicineEngName, ediCode: pillInfoModel.ediCode)
    }
}

extension PillInfo {
    public func toModel() -> PillInfoModel {
        return .init(medicineSeq: self.medicineSeq, medicineName: self.medicineName, entpSeq: self.entpSeq, entpName: self.entpName, chart: self.chart, medicineImage: self.medicineImage, printFront: self.printFront, printBack: self.printBack, medicineShape: self.medicineShape, colorClass1: self.colorClass1, colorClass2: self.colorClass2, lineFront: self.lineFront, lineBack: self.lineBack, lengLong: self.lengLong, lengShort: self.lengShort, thick: self.thick, imgRegistTs: self.imgRegistTs, classNo: self.classNo, className: self.className, etcOtcName: self.etcOtcName, medicinePermitDate: self.medicinePermitDate, formCodeName: self.formCodeName, markCodeFrontAnal: self.markCodeFrontAnal, markCodeBackAnal: self.markCodeBackAnal, markCodeFrontImg: self.markCodeFrontImg, markCodeBackImg: self.markCodeBackImg, changeDate: self.changeDate, markCodeFront: self.markCodeFront, markCodeBack: self.markCodeBack, medicineEngName: self.medicineEngName, ediCode: self.ediCode)
    }
}
