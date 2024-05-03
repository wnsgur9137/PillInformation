//
//  Timer.swift
//  AlarmDomain
//
//  Created by JunHyeok Lee on 4/25/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation

import AlarmPresentation

public struct TimerDomain {
    public let id: Int
    public let title: String?
    public let duration: TimeInterval
    public let startedDate: Date?
    public let isStarted: Bool
    
    public init(id: Int, title: String?, duration: TimeInterval, startedDate: Date?, isStarted: Bool) {
        self.id = id
        self.title = title
        self.duration = duration
        self.startedDate = startedDate
        self.isStarted = isStarted
    }
    
    public init(timerModel: TimerModel) {
        self.id = timerModel.id
        self.title = timerModel.title
        self.duration = timerModel.duration
        self.startedDate = timerModel.startedDate
        self.isStarted = timerModel.isStarted
    }
}

extension TimerDomain {
    func toModel() -> TimerModel {
        return .init(id: id, title: title, duration: duration, startedDate: startedDate, isStarted: isStarted)
    }
}
