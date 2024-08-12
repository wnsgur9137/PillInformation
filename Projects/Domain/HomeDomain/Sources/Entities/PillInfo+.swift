//
//  PillInfo+.swift
//  HomeDomain
//
//  Created by JunHyeok Lee on 7/22/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation

import BaseDomain
import BasePresentation

extension PillInfo {
    static func makePillInfo(_ pillInfoModel: PillInfoModel) -> PillInfo {
        return PillInfo(medicineSeq: pillInfoModel.medicineSeq, medicineName: pillInfoModel.medicineName, entpSeq: pillInfoModel.entpSeq, entpName: pillInfoModel.entpName, chart: pillInfoModel.chart, medicineImage: pillInfoModel.medicineImage, printFront: pillInfoModel.printFront, printBack: pillInfoModel.printBack, medicineShape: pillInfoModel.medicineShape, colorClass1: pillInfoModel.colorClass1, colorClass2: pillInfoModel.colorClass2, lineFront: pillInfoModel.lineFront, lineBack: pillInfoModel.lineBack, lengLong: pillInfoModel.lengLong, lengShort: pillInfoModel.lengShort, thick: pillInfoModel.thick, imgRegistTs: pillInfoModel.imgRegistTs, classNo: pillInfoModel.classNo, className: pillInfoModel.className, etcOtcName: pillInfoModel.etcOtcName, medicinePermitDate: pillInfoModel.medicinePermitDate, formCodeName: pillInfoModel.formCodeName, markCodeFrontAnal: pillInfoModel.markCodeFrontAnal, markCodeBackAnal: pillInfoModel.markCodeBackAnal, markCodeFrontImg: pillInfoModel.markCodeFrontImg, markCodeBackImg: pillInfoModel.markCodeBackImg, changeDate: pillInfoModel.changeDate, markCodeFront: pillInfoModel.markCodeFront, markCodeBack: pillInfoModel.markCodeBack, medicineEngName: pillInfoModel.medicineEngName, ediCode: pillInfoModel.ediCode)
    }
    
    func toModel() -> PillInfoModel {
        return .init(medicineSeq: medicineSeq, medicineName: medicineName, entpSeq: entpSeq, entpName: entpName, chart: chart, medicineImage: medicineImage, printFront: printFront, printBack: printBack, medicineShape: medicineShape, colorClass1: colorClass1, colorClass2: colorClass2, lineFront: lineFront, lineBack: lineBack, lengLong: lengLong, lengShort: lengShort, thick: thick, imgRegistTs: imgRegistTs, classNo: classNo, className: className, etcOtcName: etcOtcName, medicinePermitDate: medicinePermitDate, formCodeName: formCodeName, markCodeFrontAnal: markCodeFrontAnal, markCodeBackAnal: markCodeBackAnal, markCodeFrontImg: markCodeFrontImg, markCodeBackImg: markCodeBackImg, changeDate: changeDate, markCodeFront: markCodeFront, markCodeBack: markCodeBack, medicineEngName: medicineEngName, ediCode: ediCode)
    }
}
