//
//  DeviceCheckResultModel.swift
//  SplashPresentation
//
//  Created by JunHyeok Lee on 7/18/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation

public struct DeviceCheckResultModel {
    let bit0: Bool
    let bit1: Bool
    
    public init(bit0: Bool, bit1: Bool) {
        self.bit0 = bit0
        self.bit1 = bit1
    }
}
