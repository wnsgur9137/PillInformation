//
//  NoticeListResponseDTO.swift
//  HomeData
//
//  Created by JunHyeok Lee on 2/19/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation

public struct NoticeListResponseDTO: Decodable {
    let noticeList: [NoticeResponseDTO]
}
