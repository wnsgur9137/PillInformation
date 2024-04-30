//
//  TimerRepository.swift
//  AlarmDomain
//
//  Created by JunHyeok Lee on 4/25/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RxSwift

public protocol TimerRepository {
    func save(_ timerDomain: TimerData) -> Single<TimerData>
    func fetch(timerID: Int) -> Single<TimerData>
    func fetchAll() -> Single<[TimerData]>
    func fetchCount() -> Single<Int>
    func update(_ timerDomain: TimerData) -> Single<TimerData>
    func delete(timerID: Int) -> Single<Void>
    func deleteAll() -> Single<Void>
}
