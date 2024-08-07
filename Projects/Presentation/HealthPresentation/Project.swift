//
//  Project.swift
//  ApplicationManifests
//
//  Created by JunHyeok Lee on 8/6/24.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project: Project = .project(
    name: "HealthPresentation",
    product: .staticFramework,
    dependencies: [
        .Project.Feature.Presentation.Base
    ]
)
