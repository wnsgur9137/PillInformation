//
//  TimerModel.swift
//  AlarmPresentation
//
//  Created by JunHyeok Lee on 4/25/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation

public struct TimerModel {
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
}
