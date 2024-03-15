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
    static let FlexLayout: TargetDependency = .external(name: "FlexLayout")
    static let PinLayout: TargetDependency = .external(name: "PinLayout")
}
