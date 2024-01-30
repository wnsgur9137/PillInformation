//
//  Dependency+Framework.swift
//  MyPlugin
//
//  Created by JunHyeok Lee on 1/24/24.
//

import Foundation
import ProjectDescription

public extension TargetDependency {
    struct Framework { }
}

public extension TargetDependency.Framework {
    static let FlexLayout = TargetDependency.layout(name: "FlexLayout")
    static let PinLayout = TargetDependency.layout(name: "PinLayout")
    static let SkeletonView = TargetDependency.layout(name: "SkeletonView")
}

public extension TargetDependency {
    static func layout(name: String) -> Self {
        return .xcframework(path: .relativeToRoot("Vendor/Layout/\(name).xcframework"))
    }
}
