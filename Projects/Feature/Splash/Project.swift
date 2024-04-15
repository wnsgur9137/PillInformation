//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by JunHyeok Lee on 4/12/24.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project: Project = .project(
    name: "Splash",
    product: .staticFramework,
    dependencies: [
        .Project.Feature.Data.Splash,
        .Project.Feature.Domain.Splash,
        .Project.Feature.Presentation.Splash
    ]
)
