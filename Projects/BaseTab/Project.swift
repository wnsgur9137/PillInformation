//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by JunHyeok Lee on 3/15/24.
//

import ProjectDescription
import ProjectDescriptionHelpers
import UtilityPlugin

let project: Project = .project(
    name: "BaseTab",
    product: .staticFramework,
    dependencies: [
        .Project.Feature.Features
    ]
)
