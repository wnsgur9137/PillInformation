//
//  RecentTableViewSectionModel.swift
//  SearchPresentation
//
//  Created by JunHyoek Lee on 9/30/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RxDataSources

import BasePresentation

struct RecentTableViewSectionModel {
    var items: [String]
    var identity: String
    
    init(items: [String]) {
        self.items = items
        self.identity = UUID().uuidString
    }
}

extension RecentTableViewSectionModel: AnimatableSectionModelType {
    typealias Item = String
    
    init(original: RecentTableViewSectionModel,
         items: [String]) {
        self = original
        self.items = items
    }
}
