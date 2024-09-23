//
//  NoticeTableViewSectionModel.swift
//  HomePresentation
//
//  Created by JunHyoek Lee on 9/19/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RxDataSources

public struct NoticeTableViewSectionModel {
    public var identity: String
    public var items: [Item]
    
    init(items: [Item]) {
        self.identity = UUID().uuidString
        self.items = items
    }
}

extension NoticeTableViewSectionModel: AnimatableSectionModelType {
    public typealias Item = NoticeModel
    
    public init(original: NoticeTableViewSectionModel,
         items: [NoticeModel]) {
        self = original
        self.items = items
    }
}
