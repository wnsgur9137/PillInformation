//
//  PillShape.swift
//  SearchDomain
//
//  Created by JunHyeok Lee on 7/16/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation

import SearchPresentation

public struct PillShape {
    public let shapes: [String]?
    public let colors: [String]?
    public let lines: [String]?
    public let codes: [String]?
}

extension PillShape {
    static func create(model: PillShapeModel) -> PillShape {
        return .init(
            shapes: model.shapes.count == 0 ? nil : model.shapes,
            colors: model.colors.count == 0 ? nil : model.colors,
            lines: model.lines.count == 0 ? nil : model.lines,
            codes: model.codes.count == 0 ? nil : model.codes
        )
    }
}
