//
//  TimerDetailUseCase.swift
//  AlarmPresentation
//
//  Created by JunHyeok Lee on 4/25/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RxSwift

public protocol TimerUseCase {
    func save(_ timerModel: TimerModel) -> Single<TimerModel>
    func execute(_ timerID: Int) -> Single<TimerModel>
    func executeAll() -> Single<[TimerModel]>
    func executeCount() -> Single<Int>
    func update(_ timerModel: TimerModel) -> Single<TimerModel>
    func delete(_ timerID: Int) -> Single<Void>
    func deleteAll() -> Single<Void>
}
