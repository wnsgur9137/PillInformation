//
//  Path.swift
//  PillInformationManifests
//
//  Created by JunHyeok Lee on 3/20/24.
//

import Foundation
import ProjectDescription

public extension ProjectDescription.Path {
    static func relativeToProject(name: String) -> Self {
        return .relativeToRoot("Projects/\(name)")
    }
    static func relative(to layer: ProjectLayer) -> Self {
        return .relativeToRoot("Projects/\(layer.rawValue)/\(layer.rawValue)")
    }
    static func relative(to layer: ProjectLayer, name: String) -> Self {
        return .relativeToRoot("Projects/\(layer.rawValue)/\(name)")
    }
}
