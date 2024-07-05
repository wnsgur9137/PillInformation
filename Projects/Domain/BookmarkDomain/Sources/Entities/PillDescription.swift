//
//  PillDescription.swift
//  BookmarkDomain
//
//  Created by JunHyeok Lee on 7/5/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation

import BookmarkPresentation

public struct PillDescription {
    let medicineSeq: Int
    let medicineName: String
    let entpName: String
    let efcyQestim: String?
    let useMethodQesitm: String?
    let atpnWarnQesitm: String?
    let atpnQesitm: String?
    let intrcQesitm: String?
    let seQesitm: String?
    let depositMethodQesitm: String?
    
    public init(medicineSeq: Int, medicineName: String, entpName: String, efcyQestim: String?, useMethodQesitm: String?, atpnWarnQesitm: String?, atpnQesitm: String?, intrcQesitm: String?, seQesitm: String?, depositMethodQesitm: String?) {
        self.medicineSeq = medicineSeq
        self.medicineName = medicineName
        self.entpName = entpName
        self.efcyQestim = efcyQestim
        self.useMethodQesitm = useMethodQesitm
        self.atpnWarnQesitm = atpnWarnQesitm
        self.atpnQesitm = atpnQesitm
        self.intrcQesitm = intrcQesitm
        self.seQesitm = seQesitm
        self.depositMethodQesitm = depositMethodQesitm
    }
}

extension PillDescription {
    func toModel() -> PillDescriptionModel {
        return .init(medicineSeq: self.medicineSeq, medicineName: self.medicineName, entpName: self.entpName, efcyQestim: self.efcyQestim, useMethodQesitm: self.useMethodQesitm, atpnWarnQesitm: self.atpnWarnQesitm, intrcQesitm: self.intrcQesitm, seQesitm: self.seQesitm, depositMethodQesitm: self.depositMethodQesitm)
    }
}
