//
//  PillInfoObject+.swift
//  BookmarkData
//
//  Created by JunHyeok Lee on 7/5/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RealmSwift

import BaseData

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
