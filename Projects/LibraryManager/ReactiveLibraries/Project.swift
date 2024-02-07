//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by JunHyeok Lee on 1/31/24.
//

import ProjectDescription
import ProjectDescriptionHelpers
import UtilityPlugin

let project: Project = .framework(
    name: "ReactiveLibraries",
    packages: Package.Reactive.package,
    dependencies: TargetDependency.SwiftPM.Reactive.package
)
