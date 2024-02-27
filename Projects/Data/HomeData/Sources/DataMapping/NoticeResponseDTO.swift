//
//  NoticeResponseDTO.swift
//  HomeData
//
//  Created by JunHyeok Lee on 2/19/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import HomeDomain

public struct NoticeResponseDTO: Decodable {
    let title: String
    let writer: String
    let content: String
    let writedDate: Date?
}

extension NoticeResponseDTO {
    func toDomain() -> Notice {
        .init(title: self.title, writer: self.writer, content: self.content, writedDate: self.writedDate)
    }
}
