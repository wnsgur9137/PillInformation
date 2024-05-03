//
//  AlarmUseCase.swift
//  AlarmPresentation
//
//  Created by JunHyeok Lee on 5/2/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RxSwift

public protocol AlarmUseCase {
    func save(_ alarmModel: AlarmModel) -> Single<AlarmModel>
    func execute(alarmID: Int) -> Single<AlarmModel>
    func executeAll() -> Single<[AlarmModel]>
    func executeCount() -> Single<Int>
    func update(_ alarmModel: AlarmModel) -> Single<AlarmModel>
    func delete(_ timerID: Int) -> Single<Void>
    func deleteAll() -> Single<Void>
}
