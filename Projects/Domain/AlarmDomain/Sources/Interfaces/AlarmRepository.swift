//
//  AlarmRepository.swift
//  AlarmDomain
//
//  Created by JunHyeok Lee on 5/2/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RxSwift

public protocol AlarmRepository {
    func save(_ alarm: Alarm) -> Single<Alarm>
    func fetch(alarmID: Int) -> Single<Alarm>
    func fetchAll() -> Single<[Alarm]>
    func fetchCount() -> Single<Int>
    func update(_ alarm: Alarm) -> Single<Alarm>
    func delete(alarmID: Int) -> Single<Void>
    func deleteAll() -> Single<Void>
}
