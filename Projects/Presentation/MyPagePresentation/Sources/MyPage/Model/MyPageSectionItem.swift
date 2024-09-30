//
//  MyPageSectionItem.swift
//  MyPagePresentation
//
//  Created by JunHyoek Lee on 9/24/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RxDataSources

struct MyPageSectionItem {
    var header: String?
    var items: [Item]
    
    init(header: String?, items: [Item]) {
        self.header = header
        self.items = items
    }
}

extension MyPageSectionItem: SectionModelType {
    typealias Item = String?
    
    init(original: MyPageSectionItem, items: [String?]) {
        self = original
        self.items = items
    }
}
