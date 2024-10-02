//
//  AlarmSettingTableViewSectionItem.swift
//  MyPagePresentation
//
//  Created by JunHyoek Lee on 10/2/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RxDataSources

public struct AlarmSettingTableViewSectionItem {
    public var items: [Item]
    
    public init(items: [Item]) {
        self.items = items
    }
}

extension AlarmSettingTableViewSectionItem: SectionModelType {
    public typealias Item = AlarmSettingCellInfo
    
    public init(original: AlarmSettingTableViewSectionItem, items: [AlarmSettingCellInfo]) {
        self = original
        self.items = items
    }
}
