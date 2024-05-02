//
//  AlarmObject.swift
//  AlarmData
//
//  Created by JunHyeok Lee on 5/2/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RealmSwift

public class AlarmObject: Object {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var title: String?
    @Persisted var alarmTime: Date
    @Persisted var week: WeekObject?
    @Persisted var isActive: Bool
    
    convenience init(id: Int, title: String?, alarmTime: Date, week: WeekDTO, isActive: Bool) {
        self.init()
        self.id = id
        self.title = title
        self.alarmTime = alarmTime
        self.week = WeekObject(id: self.id, weekDTO: week)
        self.isActive = isActive
    }
    
    convenience init(alarmDTO: AlarmDTO) {
        self.init()
        self.id = alarmDTO.id
        self.title = alarmDTO.title
        self.alarmTime = alarmDTO.alarmTime
        self.week = WeekObject(id: alarmDTO.id, weekDTO: alarmDTO.week)
        self.isActive = alarmDTO.isActive
    }
}

extension AlarmObject {
    func toDTO() -> AlarmDTO {
        return .init(id: id, title: title, alarmTime: alarmTime, week: week?.toDTO() ?? .init(), isActive: isActive)
    }
}

public class WeekObject: Object {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var sunday: Bool
    @Persisted var monday: Bool
    @Persisted var tuesday: Bool
    @Persisted var wednesday: Bool
    @Persisted var thursday: Bool
    @Persisted var friday: Bool
    @Persisted var saturday: Bool
    
    convenience init(id: Int, sunday: Bool, monday: Bool, tuesday: Bool, wednesday: Bool, thursday: Bool, friday: Bool, saturday: Bool) {
        self.init()
        self.id = id
        self.sunday = sunday
        self.monday = monday
        self.tuesday = tuesday
        self.wednesday = wednesday
        self.thursday = thursday
        self.friday = friday
        self.saturday = saturday
    }
    
    convenience init(id: Int, weekDTO: WeekDTO?) {
        self.init()
        self.id = id
        self.sunday = weekDTO?.sunday ?? false
        self.monday = weekDTO?.monday ?? false
        self.tuesday = weekDTO?.tuesday ?? false
        self.wednesday = weekDTO?.wednesday ?? false
        self.thursday = weekDTO?.thursday ?? false
        self.friday = weekDTO?.friday ?? false
        self.saturday = weekDTO?.saturday ?? false
    }
}

extension WeekObject {
    func toDTO() -> WeekDTO {
        return .init(sunday: sunday, monday: monday, tuesday: tuesday, wednesday: wednesday, thursday: thursday, friday: friday, saturday: saturday)
    }
}
