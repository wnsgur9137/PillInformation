//
//  NoticeModel.swift
//  HomePresentation
//
//  Created by JunHyeok Lee on 3/21/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RxDataSources

public struct NoticeModel: Equatable, IdentifiableType {
    public let title: String
    public let writer: String
    public let content: String
    public let writedDate: Date?
    public let identity: String?
    
    public init(title: String, writer: String, content: String, writedDate: Date?) {
        self.title = title
        self.writer = writer
        self.content = content
        self.writedDate = writedDate
        self.identity = UUID().uuidString
    }
}
