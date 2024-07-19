//
//  DeviceCheckResult.swift
//  SplashDomain
//
//  Created by JunHyeok Lee on 7/18/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation

import SplashPresentation

public struct DeviceCheckResult {
    let bit0: Bool
    let bit1: Bool
    let lastUpdated: String
    
    public init(bit0: Bool, bit1: Bool, lastUpdated: String) {
        self.bit0 = bit0
        self.bit1 = bit1
        self.lastUpdated = lastUpdated
    }
}

extension DeviceCheckResult {
    func toModel() -> DeviceCheckResultModel {
        return .init(bit0: bit0, bit1: bit1)
    }
}
