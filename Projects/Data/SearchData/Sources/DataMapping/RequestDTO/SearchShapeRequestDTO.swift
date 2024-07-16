//
//  SearchShapeRequestDTO.swift
//  SearchData
//
//  Created by JunHyeok Lee on 7/16/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation

import SearchDomain

public struct SearchShapeRequestDTO {
    let shapes: [String]?
    let colors: [String]?
    let lines: [String]?
    let codes: [String]?
}

extension SearchShapeRequestDTO {
    static func create(shapeInfo: PillShape) -> SearchShapeRequestDTO {
        return .init(shapes: shapeInfo.shapes, colors: shapeInfo.colors, lines: shapeInfo.lines, codes: shapeInfo.codes)
    }
}
