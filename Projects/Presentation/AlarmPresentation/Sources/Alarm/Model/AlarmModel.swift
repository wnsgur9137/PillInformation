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
    public let week: WeekModel
    
    public init(id: Int, title: String?, alarmTime: Date, week: WeekModel) {
        self.id = id
        self.title = title
        self.alarmTime = alarmTime
        self.week = week
    }
}

public struct WeekModel {
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
}
