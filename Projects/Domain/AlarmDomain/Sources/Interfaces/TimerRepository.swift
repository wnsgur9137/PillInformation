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
    func save(_ timerDomain: TimerDomain) -> Single<TimerDomain>
    func fetch(timerID: Int) -> Single<TimerDomain>
    func fetchAll() -> Single<[TimerDomain]>
    func fetchCount() -> Single<Int>
    func update(_ timerDomain: TimerDomain) -> Single<TimerDomain>
    func delete(timerID: Int) -> Single<Void>
    func deleteAll() -> Single<Void>
}
