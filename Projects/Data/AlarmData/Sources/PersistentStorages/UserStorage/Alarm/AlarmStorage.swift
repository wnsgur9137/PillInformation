//
//  AlarmStorage.swift
//  AlarmData
//
//  Created by JunHyeok Lee on 5/2/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RxSwift

public protocol AlarmStorage {
    func save(response: AlarmDTO) -> Single<AlarmDTO>
    func get(alarmID: Int) -> Single<AlarmDTO>
    func getAll() -> Single<[AlarmDTO]>
    func getCount() -> Single<Int>
    func update(updatedResponse: AlarmDTO) -> Single<AlarmDTO>
    func delete(alarmID: Int) -> Single<Void>
    func deleteAll() -> Single<Void>
}
