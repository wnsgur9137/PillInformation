//
//  NoticeModel.swift
//  HomePresentation
//
//  Created by JunHyeok Lee on 3/21/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation

public struct NoticeModel {
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
