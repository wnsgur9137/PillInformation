//
//  Project1.swift
//  ApplicationManifests
//
//  Created by JunHyeok Lee on 3/19/24.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project: Project = .project(
    name: "Onboarding",
    product: .staticFramework,
    dependencies: [
        .Project.Feature.Data.Onboarding,
        .Project.Feature.Domain.Onboarding,
        .Project.Feature.Presentation.Onboarding
    ],
    hasTest: true,
    hasDemoApp: true
)
