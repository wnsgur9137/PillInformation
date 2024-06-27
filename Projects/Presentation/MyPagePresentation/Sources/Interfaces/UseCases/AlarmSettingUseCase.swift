//
//  AlarmSettingUseCase.swift
//  MyPagePresentation
//
//  Created by JunHyeok Lee on 6/27/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RxSwift

public protocol AlarmSettingUseCase {
    func fetchAlarmSetting() -> Single<AlarmSettingModel>
    func updateAlarmSetting(_ alarmSettingModel: AlarmSettingModel) -> Single<AlarmSettingModel>
}
