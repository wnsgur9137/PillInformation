//
//  ApplicationSplashRepository.swift
//  SplashDomain
//
//  Created by JunHyeok Lee on 7/19/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RxSwift

public protocol ApplicationSplashRepository {
    func deviceCheck(_ deviceToken: String) -> Single<DeviceCheckResult>
    func executeIsNeedSignIn() -> Single<Bool>
    func executeIsShowAlarmTab() -> Single<Bool>
}
