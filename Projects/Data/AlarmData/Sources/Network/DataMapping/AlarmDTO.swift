//
//  AlarmDTO.swift
//  AlarmData
//
//  Created by JunHyeok Lee on 5/2/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation

import AlarmDomain

public struct AlarmDTO: Decodable {
    let id: Int
    let title: String?
    let alarmTime: Date
    let week: WeekDTO
    let isActive: Bool
    
    init(id: Int, title: String?, alarmTime: Date, week: WeekDTO, isActive: Bool) {
        self.id = id
        self.title = title
        self.alarmTime = alarmTime
        self.week = week
        self.isActive = isActive
    }
    
    init(alarm: Alarm) {
        self.id = alarm.id
        self.title = alarm.title
        self.alarmTime = alarm.alarmTime
        self.week = WeekDTO(weekDomain: alarm.week)
        self.isActive = alarm.isActive
    }
}

extension AlarmDTO {
    func toDomain() -> Alarm {
        return .init(id: id, title: title, alarmTime: alarmTime, week: week.toDomain(), isActive: isActive)
    }
}

struct WeekDTO: Decodable {
    let sunday: Bool
    let monday: Bool
    let tuesday: Bool
    let wednesday: Bool
    let thursday: Bool
    let friday: Bool
    let saturday: Bool
    
    init(sunday: Bool = false,
                monday: Bool = false,
                tuesday: Bool = false,
                wednesday: Bool = false,
                thursday: Bool = false,
                friday: Bool = false,
                saturday: Bool = false) {
        self.sunday = sunday
        self.monday = monday
        self.tuesday = tuesday
        self.wednesday = wednesday
        self.thursday = thursday
        self.friday = friday
        self.saturday = saturday
    }
    
    init(weekDomain: WeekDomain) {
        self.sunday = weekDomain.sunday
        self.monday = weekDomain.monday
        self.tuesday = weekDomain.tuesday
        self.wednesday = weekDomain.wednesday
        self.thursday = weekDomain.thursday
        self.friday = weekDomain.friday
        self.saturday = weekDomain.saturday
    }
}

extension WeekDTO {
    func toDomain() -> WeekDomain {
        return .init(sunday: sunday, monday: monday, tuesday: tuesday, wednesday: wednesday, thursday: thursday, friday: friday, saturday: saturday)
    }
}
