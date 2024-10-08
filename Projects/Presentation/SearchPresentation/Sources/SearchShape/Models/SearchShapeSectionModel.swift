//
//  SearchShapeSectionModel.swift
//  SearchPresentation
//
//  Created by JunHyoek Lee on 10/8/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RxDataSources

struct SearchShapeSectionModel {
    var items: [Item]
    
    init(items: [Item]) {
        self.items = items
    }
}

extension SearchShapeSectionModel: SectionModelType {
    typealias Item = SearchShapeSection
    
    enum SearchShapeSection {
        case shape(ShapeSection)
        case code
        case search
    }
    
    enum ShapeSection {
        case color((color: SearchColorItems, isSelected: Bool))
        case shape((shape: SearchShapeItems, isSelected: Bool))
        case line((line: SearchLineItems, isSelected: Bool))
    }
    
    init(original: SearchShapeSectionModel, items: [SearchShapeSection]) {
        self = original
        self.items = items
    }
}
