//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by JunHyeok Lee on 1/31/24.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project: Project = .framework(
    name: "Reactive",
    packages: Package.Reactive.package,
    dependencies: TargetDependency.SwiftPM.Reactive.package
)
