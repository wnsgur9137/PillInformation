//
//  Dependency+Carthage.swift
//  MyPlugin
//
//  Created by JunHyeok Lee on 1/24/24.
//

import Foundation
import ProjectDescription

// MARK: - Carthage
public extension TargetDependency {
    struct Carthage { }
}

public extension TargetDependency.Carthage {
    static let FlexLayout: TargetDependency = .carthage(name: "FlexLayout")
    static let PinLayout: TargetDependency = .carthage(name: "PinLayout")
}

public extension TargetDependency {
    static func carthage(name: String) -> Self {
        return .xcframework(path: .relativeToCarthage("\(name).xcframework"))
    }
}
