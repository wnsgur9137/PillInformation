//
//  AlarmSettingCellInfo.swift
//  MyPagePresentation
//
//  Created by JunHyeok Lee on 6/27/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RxDataSources

public struct AlarmSettingCellInfo {
    public let title: String
    public let content: String
    public let isAgree: Bool
    
    public init(title: String,
                content: String,
                isAgree: Bool) {
        self.title = title
        self.content = content
        self.isAgree = isAgree
    }
}
