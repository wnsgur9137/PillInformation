//
//  NetworkManager+Splash.swift
//  SplashData
//
//  Created by JunHyeok Lee on 7/18/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RxSwift
import Moya

import NetworkInfra
import SplashDomain

extension NetworkManager {
    public func requestDeviceCheck(_ deviceToken: String) -> Single<DeviceCheckResultResponseDTO> {
        return requestObject(.deviceCheck(deviceToken: deviceToken), type: DeviceCheckResultResponseDTO.self)
    }
    
    public func requestIsNeedSignIn() -> Single<Bool> {
        return requestObject(.isNeedSignIn, type: Bool.self)
    }
    
    public func requestIsShowAlarmTab() -> Single<Bool> {
        return requestObject(.isShowAlarmTab, type: Bool.self)
    }
}
