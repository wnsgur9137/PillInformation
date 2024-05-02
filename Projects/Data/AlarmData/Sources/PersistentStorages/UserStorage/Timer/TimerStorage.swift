//
//  TimerStorage.swift
//  AlarmData
//
//  Created by JunHyeok Lee on 4/25/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RxSwift

public protocol TimerStorage {
    func save(response: TimerDTO) -> Single<TimerDTO>
    func get(timerID: Int) -> Single<TimerDTO>
    func getAll() -> Single<[TimerDTO]>
    func getCount() -> Single<Int>
    func update(updatedResponse: TimerDTO) -> Single<TimerDTO>
    func delete(timerID: Int) -> Single<Void>
    func deleteAll() -> Single<Void>
}
