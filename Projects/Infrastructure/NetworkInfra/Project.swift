//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by JunHyeok Lee on 1/25/24.
//

import ProjectDescription
import ProjectDescriptionHelpers
import UtilityPlugin

let project = Project.staticFramework(
    name: "NetworkInfra",
    dependencies: [
    ] + TargetDependency.SwiftPM.Network.package
    + TargetDependency.SwiftPM.Reactive.package
)
