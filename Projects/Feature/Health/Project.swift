//
//  Project.swift
//  ApplicationManifests
//
//  Created by JunHyeok Lee on 8/6/24.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project: Project = .project(
    name: "Health",
    product: .staticFramework,
    dependencies: [
        .Project.Feature.Data.Health,
        .Project.Feature.Domain.Health,
        .Project.Feature.Presentation.Health
    ]
)
