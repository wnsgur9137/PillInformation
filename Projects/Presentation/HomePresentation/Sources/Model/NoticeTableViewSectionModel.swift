//
//  NoticeTableViewSectionModel.swift
//  HomePresentation
//
//  Created by JunHyoek Lee on 9/19/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RxDataSources

struct NoticeTableViewSectionModel {
    var identity: String
    var items: [Item]
    
    init(items: [Item]) {
        self.identity = UUID().uuidString
        self.items = items
    }
}

extension NoticeTableViewSectionModel: AnimatableSectionModelType {
    typealias Item = NoticeModel
    
    init(original: NoticeTableViewSectionModel,
         items: [NoticeModel]) {
        self = original
        self.items = items
    }
}
