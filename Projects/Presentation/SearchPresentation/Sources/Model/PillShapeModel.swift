//
//  PillShapeModel.swift
//  SearchPresentation
//
//  Created by JunHyeok Lee on 7/16/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation

public struct PillShapeModel {
    public var shapes: [String]
    public var colors: [String]
    public var lines: [String]
    public var codes: [String]
    
    init() {
        self.shapes = []
        self.colors = []
        self.lines = []
        self.codes = []
    }
    
    init(shapes: [String],
         colors: [String],
         lines: [String],
         codes: [String]) {
        self.shapes = shapes
        self.colors = colors
        self.lines = lines
        self.codes = codes
    }
}
