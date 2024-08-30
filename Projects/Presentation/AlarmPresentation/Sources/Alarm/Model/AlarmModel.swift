//
//  AlarmModel.swift
//  AlarmPresentation
//
//  Created by JunHyeok Lee on 4/30/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation

public struct AlarmModel {
    public let id: Int
    public let title: String?
    public let alarmTime: Date
    public var week: WeekModel
    public var isActive: Bool
    
    public init(id: Int, title: String?, alarmTime: Date, week: WeekModel, isActive: Bool) {
        self.id = id
        self.title = title
        self.alarmTime = alarmTime
        self.week = week
        self.isActive = isActive
    }
}

public struct WeekModel: Equatable {
    public var sunday: Bool
    public var monday: Bool
    public var tuesday: Bool
    public var wednesday: Bool
    public var thursday: Bool
    public var friday: Bool
    public var saturday: Bool
    
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
}
