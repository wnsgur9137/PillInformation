//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by JunHyeok Lee on 1/31/24.
//

import ProjectDescription
import ProjectDescriptionHelpers
import UtilityPlugin

let project: Project = .project(
    name: "UILibraries",
    product: .framework,
    packages: [
        .UI.KingFihser,
        .UI.SkeletonView,
        .UI.DropDown,
    ],
    dependencies: [
        .SwiftPM.UI.KingFisher,
        .SwiftPM.UI.SkeletonView,
        .SwiftPM.UI.DropDown
    ]
)

