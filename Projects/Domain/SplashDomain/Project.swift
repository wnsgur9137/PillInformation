//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by JunHyeok Lee on 4/12/24.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project: Project = .project(
    name: "SplashDomain",
    product: .staticFramework,
    dependencies: [
        .Project.Feature.Domain.Base,
        .Project.Feature.Presentation.Splash
    ]
)
