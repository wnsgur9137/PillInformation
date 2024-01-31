//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by JunHyeok Lee on 1/31/24.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project: Project = .framework(
    name: "Network",
    packages: Package.Network.package,
    dependencies: TargetDependency.SwiftPM.Network.package
)
