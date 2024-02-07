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
    name: "LayoutLibraries",
    packages: Package.Layout.package,
    dependencies: TargetDependency.SwiftPM.Layout.package
)
