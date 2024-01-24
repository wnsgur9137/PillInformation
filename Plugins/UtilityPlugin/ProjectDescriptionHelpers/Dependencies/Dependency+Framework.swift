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
    static let FlexLayout = TargetDependency.designSystem(name: "FlexLayout")
    static let PinLayout = TargetDependency.designSystem(name: "PinLayout")
    static let SkeletonView = TargetDependency.designSystem(name: "SkeletonView")
}

public extension TargetDependency {
    static func designSystem(name: String) -> Self {
        return .xcframework(path: .relativeToRoot("Vendor/DesignSystem/\(name).xcframework"))
    }
}
