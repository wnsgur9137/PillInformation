//
//  RecommendCollectionViewSectionModel.swift
//  HomePresentation
//
//  Created by JunHyoek Lee on 9/19/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RxDataSources

import BasePresentation

struct RecommendCollectionViewSectionModel {
    var headerTitle: String
    var items: [Item]
    var identity: String
    
    init(headerTitle: String,
         items: [Item]) {
        self.headerTitle = headerTitle
        self.items = items
        self.identity = UUID().uuidString
    }
}

extension RecommendCollectionViewSectionModel: AnimatableSectionModelType {
    enum Item: Equatable, IdentifiableType {
        case shortcut(HomeShortcutButtonInfo)
        case recommendPills(PillInfoModel)
        
        var identity: String {
            return UUID().uuidString
        }
    }
    
    init(original: RecommendCollectionViewSectionModel,
         items: [Item]) {
        self = original
        self.items = items
    }
}
