//
//  Alarm.swift
//  AlarmDomain
//
//  Created by JunHyeok Lee on 5/2/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation

import AlarmPresentation

public struct Alarm {
    public let id: Int
    public let title: String?
    public let alarmTime: Date
    public let week: WeekDomain
    public let isActive: Bool
    
    public init(id: Int, title: String?, alarmTime: Date, week: WeekDomain, isActive: Bool) {
        self.id = id
        self.title = title
        self.alarmTime = alarmTime
        self.week = week
        self.isActive = isActive
    }
    
    init(alarmModel: AlarmModel) {
        self.id = alarmModel.id
        self.title = alarmModel.title
        self.alarmTime = alarmModel.alarmTime
        self.week = WeekDomain(weekModel: alarmModel.week)
        self.isActive = alarmModel.isActive
    }
}

extension Alarm {
    func toModel() -> AlarmModel {
        return .init(id: id, title: title, alarmTime: alarmTime, week: week.toModel(), isActive: isActive)
    }
}

public struct WeekDomain {
    public let sunday: Bool
    public let monday: Bool
    public let tuesday: Bool
    public let wednesday: Bool
    public let thursday: Bool
    public let friday: Bool
    public let saturday: Bool
    
    public init(sunday: Bool = false,
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
    
    init(weekModel: WeekModel) {
        self.sunday = weekModel.sunday
        self.monday = weekModel.monday
        self.tuesday = weekModel.tuesday
        self.wednesday = weekModel.wednesday
        self.thursday = weekModel.thursday
        self.friday = weekModel.friday
        self.saturday = weekModel.saturday
    }
}

extension WeekDomain {
    func toModel() -> WeekModel {
        return .init(sunday: sunday, monday: monday, tuesday: tuesday, wednesday: wednesday, thursday: thursday, friday: friday, saturday: saturday)
    }
}
