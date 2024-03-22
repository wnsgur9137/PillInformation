//
//  Project1.swift
//  ApplicationManifests
//
//  Created by JunHyeok Lee on 3/19/24.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project: Project = .project(
    name: "OnboardingDomain",
    product: .staticFramework,
    dependencies: [
        .Project.Feature.Domain.Base,
        .Project.Feature.Presentation.Onboarding
    ]
)
