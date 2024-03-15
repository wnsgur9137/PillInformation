//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by JunHyeok Lee on 2/6/24.
//

import ProjectDescription
import ProjectDescriptionHelpers
import UtilityPlugin

let project: Project = .project(
    name: "Onboarding",
    product: .staticFramework,
    dependencies: [
        .Project.Feature.Presentation.Onboarding,
        .Project.Feature.Domain.Onboarding,
        .Project.Feature.Data.Onboarding
    ]
)
