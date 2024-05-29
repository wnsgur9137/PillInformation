//
//  PillDescriptionModel.swift
//  SearchPresentation
//
//  Created by JunHyeok Lee on 5/24/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation

public struct PillDescriptionModel {
    let medicineSeq: Int
    let medicineName: String
    let entpName: String
    let efcyQestim: String?
    let useMethodQesitm: String?
    let atpnWarnQesitm: String?
    let intrcQesitm: String?
    let seQesitm: String?
    let depositMethodQesitm: String?
    
    public init(medicineSeq: Int, medicineName: String, entpName: String, efcyQestim: String?, useMethodQesitm: String?, atpnWarnQesitm: String?, intrcQesitm: String?, seQesitm: String?, depositMethodQesitm: String?) {
        self.medicineSeq = medicineSeq
        self.medicineName = medicineName
        self.entpName = entpName
        self.efcyQestim = efcyQestim
        self.useMethodQesitm = useMethodQesitm
        self.atpnWarnQesitm = atpnWarnQesitm
        self.intrcQesitm = intrcQesitm
        self.seQesitm = seQesitm
        self.depositMethodQesitm = depositMethodQesitm
    }
}
