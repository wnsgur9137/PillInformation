//
//  NoticeListResponseDTO.swift
//  HomeData
//
//  Created by JunHyeok Lee on 3/21/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation

struct NoticeListResponseDTO: Decodable {
    let noticeList: [NoticeResponseDTO]
}
