//
//  DeviceCheckResultResponseDTO.swift
//  SplashData
//
//  Created by JunHyeok Lee on 7/18/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation

import SplashDomain

public struct DeviceCheckResultResponseDTO: Decodable {
    let bit0: Bool
    let bit1: Bool
    let lastUpdated: String
}

extension DeviceCheckResultResponseDTO {
    func toDomain() -> DeviceCheckResult {
        return .init(bit0: bit0, bit1: bit1, lastUpdated: lastUpdated)
    }
}
