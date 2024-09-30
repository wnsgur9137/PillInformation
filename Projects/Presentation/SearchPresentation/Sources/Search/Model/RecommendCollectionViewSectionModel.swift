//
//  RecommendCollectionViewSectionModel.swift
//  SearchPresentation
//
//  Created by JunHyoek Lee on 9/30/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RxDataSources

import BasePresentation

struct RecommendCollectionViewSectionModel {
    var items: [Item]
    var identity: String
    
    init(items: [Item]) {
        self.items = items
        self.identity = UUID().uuidString
    }
}

extension RecommendCollectionViewSectionModel: AnimatableSectionModelType {
    typealias Item = String
    
    init(original: RecommendCollectionViewSectionModel, items: [String]) {
        self = original
        self.items = items
    }
}
