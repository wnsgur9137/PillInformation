//
//  DefaultApplicationSplashRepository.swift
//  SplashData
//
//  Created by JunHyeok Lee on 7/19/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RxSwift

import NetworkInfra
import SplashDomain

public struct DefaultApplicationSplashRepository: ApplicationSplashRepository {
    private let network: NetworkManager
    
    public init(network: NetworkManager) {
        self.network = network
    }
}

extension DefaultApplicationSplashRepository {
    public func deviceCheck(_ deviceToken: String) -> Single<DeviceCheckResult> {
        network.requestDeviceCheck(deviceToken).map { $0.toDomain() }
    }
    
    public func executeIsNeedSignIn() -> Single<Bool> {
        network.requestIsNeedSignIn()
    }
    
    public func executeIsShowAlarmTab() -> Single<Bool> {
        network.requestIsShowAlarmTab()
    }
}
