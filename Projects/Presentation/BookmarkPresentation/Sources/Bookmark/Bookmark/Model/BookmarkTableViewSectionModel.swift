//
//  BookmarkTableViewSectionModel.swift
//  BookmarkPresentation
//
//  Created by JunHyoek Lee on 9/19/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RxDataSources

import BasePresentation

struct BookmarkTableViewSectionModel {
    var identity: String
    var items: [Item]
    
    init(items: [Item]) {
        self.identity = UUID().uuidString
        self.items = items
    }
}

extension BookmarkTableViewSectionModel: AnimatableSectionModelType {
    typealias Item = PillInfoModel
    
    init(original: BookmarkTableViewSectionModel, items: [PillInfoModel]) {
        self = original
        self.items = items
    }
}
