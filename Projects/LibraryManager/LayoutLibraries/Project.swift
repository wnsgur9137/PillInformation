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
    name: "LayoutLibraries",
    product: .framework,
    dependencies: [
        .Carthage.FlexLayout,
        .Carthage.PinLayout
    ]
)
