//
//  SearchResultSectionedItem.swift
//  SearchPresentation
//
//  Created by JunHyoek Lee on 10/4/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RxDataSources

import BasePresentation

struct SearchResultSectionedItem {
    var items: [Item]
    
    init(items: [Item]) {
        self.items = items
    }
}

extension SearchResultSectionedItem: SectionModelType {
    typealias Item = (pill: PillInfoModel, isBookmarked: Bool)
    
    init(original: SearchResultSectionedItem, items: [(pill: PillInfoModel, isBookmarked: Bool)]) {
        self = original
        self.items = items
    }
}
