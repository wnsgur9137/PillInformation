//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by JunHyeok Lee on 1/31/24.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project: Project = .framework(
    name: "UI",
    packages: Package.UI.package,
    dependencies: TargetDependency.SwiftPM.UI.package
)
