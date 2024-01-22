//
//  Path.swift
//  ProjectDescriptionHelpers
//
//  Created by JUNHYEOK LEE on 1/22/24.
//

import Foundation
import ProjectDescription

public extension ProjectDescription.Path {
    static var application: Self {
        return .relativeToRoot("Projects/Application")
    }
    static func relativeToXCConfig(_ scheme: AppConfiguration, path: String) -> Self {
        return .relativeToRoot("XCConfig/\(path)/\(scheme.rawValue).xcconfig")
    }
    static func relativeToXCConfig(name: String, path: String) -> Self {
        return .relativeToRoot("XCConfig/\(path)/\(name).xcconfig")
    }
    static func relative(to layer: ProjectLayer, name: String) -> Self {
        return .relativeToRoot("Projects/\(layer)/\(name)")
    }
    static func relative(to layer: ProjectLayer, view: ProjectView) -> Self {
        return .relativeToRoot("Projects/\(layer)/\(view)")
    }
}
