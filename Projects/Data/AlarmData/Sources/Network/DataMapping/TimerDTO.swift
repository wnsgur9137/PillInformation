//
//  TimerDTO.swift
//  AlarmData
//
//  Created by JunHyeok Lee on 4/25/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation

import AlarmDomain

public struct TimerDTO: Decodable {
    let id: Int
    let title: String?
    let duration: TimeInterval
    let startedDate: Date?
    let isStarted: Bool
    
    init(id: Int, title: String?, duration: TimeInterval, startedDate: Date?, isStarted: Bool) {
        self.id = id
        self.title = title
        self.duration = duration
        self.startedDate = startedDate
        self.isStarted = isStarted
    }
    
    init(timerData: TimerDomain) {
        self.id = timerData.id
        self.title = timerData.title
        self.duration = timerData.duration
        self.startedDate = timerData.startedDate
        self.isStarted = timerData.isStarted
    }
}

extension TimerDTO {
    func toDomain() -> TimerDomain {
        return .init(id: id, title: title, duration: duration, startedDate: startedDate, isStarted: isStarted)
    }
}
