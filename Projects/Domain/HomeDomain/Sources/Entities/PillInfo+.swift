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
    func toModel() -> PillInfoModel {
        return .init(medicineSeq: medicineSeq, medicineName: medicineName, entpSeq: entpSeq, entpName: entpName, chart: chart, medicineImage: medicineImage, printFront: printFront, printBack: printBack, medicineShape: medicineShape, colorClass1: colorClass1, colorClass2: colorClass2, lineFront: lineFront, lineBack: lineBack, lengLong: lengLong, lengShort: lengShort, thick: thick, imgRegistTs: imgRegistTs, classNo: classNo, className: className, etcOtcName: etcOtcName, medicinePermitDate: medicinePermitDate, formCodeName: formCodeName, markCodeFrontAnal: markCodeFrontAnal, markCodeBackAnal: markCodeBackAnal, markCodeFrontImg: markCodeFrontImg, markCodeBackImg: markCodeBackImg, changeDate: changeDate, markCodeFront: markCodeFront, markCodeBack: markCodeBack, medicineEngName: medicineEngName, ediCode: ediCode)
    }
}
