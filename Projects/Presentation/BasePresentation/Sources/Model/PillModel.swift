//
//  PillModel.swift
//  BasePresentation
//
//  Created by JunHyeok Lee on 7/5/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation

public struct PillModel {
    public var info: PillInfoModel
    public var description: PillDescriptionModel?
    
    public init(info: PillInfoModel,
                description: PillDescriptionModel? = nil) {
        self.info = info
        self.description = description
    }
    
    public mutating func addDescription(_ description: PillDescriptionModel) {
        self.description = description
    }
}
