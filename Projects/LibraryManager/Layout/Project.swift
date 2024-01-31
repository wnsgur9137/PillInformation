//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by JunHyeok Lee on 1/31/24.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project: Project = .framework(
    name: "Layout",
    packages: Package.Layout.package,
    dependencies: [
        .SwiftPM.Layout.flexLayout,
        .SwiftPM.Layout.pinLayout
    ]
)
