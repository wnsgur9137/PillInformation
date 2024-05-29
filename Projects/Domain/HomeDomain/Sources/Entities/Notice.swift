//
//  Notice.swift
//  HomeDomain
//
//  Created by JUNHYEOK LEE on 2/17/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import HomePresentation

public struct Notice {
    public let title: String
    public let writer: String
    public let content: String
    public let writedDate: Date?
    
    public init(title: String, writer: String, content: String, writedDate: Date?) {
        self.title = title
        self.writer = writer
        self.content = content
        self.writedDate = writedDate
    }
}

extension Notice {
    func toModel() -> NoticeModel {
        return .init(title: self.title,
                     writer: self.writer,
                     content: self.content,
                     writedDate: self.writedDate)
    }
}
