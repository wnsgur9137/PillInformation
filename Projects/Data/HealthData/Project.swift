//
//  Project.swift
//  ApplicationManifests
//
//  Created by JunHyeok Lee on 8/6/24.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project: Project = .project(
    name: "HealthData",
    product: .staticFramework,
    dependencies: [
        .Project.Feature.Data.Base,
        .Project.Feature.Domain.Health
    ]
)

