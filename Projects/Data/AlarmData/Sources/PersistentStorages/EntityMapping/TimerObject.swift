//
//  TimerObject.swift
//  AlarmData
//
//  Created by JunHyeok Lee on 4/25/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RealmSwift

class TimerObject: Object {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var title: String?
    @Persisted var duration: TimeInterval
    @Persisted var startedDate: Date?
    @Persisted var isStarted: Bool
    
    convenience init(id: Int, title: String?, duration: TimeInterval, startedDate: Date?, isStarted: Bool) {
        self.init()
        self.id = id
        self.title = title
        self.duration = duration
        self.startedDate = startedDate
        self.isStarted = isStarted
    }
    
    convenience init(timerDTO: TimerDTO) {
        self.init()
        self.id = timerDTO.id
        self.title = timerDTO.title
        self.duration = timerDTO.duration
        self.startedDate = timerDTO.startedDate
        self.isStarted = timerDTO.isStarted
    }
}

extension TimerObject {
    func toDTO() -> TimerDTO {
        return .init(id: id, title: title, duration: duration, startedDate: startedDate, isStarted: isStarted)
    }
}
