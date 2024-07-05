//
//  PillDescription.swift
//  BaseDomain
//
//  Created by JunHyeok Lee on 7/5/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation

public struct PillDescription {
    public let medicineSeq: Int
    public let medicineName: String
    public let entpName: String
    public let efcyQestim: String?
    public let useMethodQesitm: String?
    public let atpnWarnQesitm: String?
    public let atpnQesitm: String?
    public let intrcQesitm: String?
    public let seQesitm: String?
    public let depositMethodQesitm: String?
    
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
