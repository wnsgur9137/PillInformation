//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by JunHyeok Lee on 3/21/24.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project: Project = .project(
    name: "InfraInjectionManager",
    product: .staticFramework,
    dependencies: [
        .Project.Infrastructure.Network,
        .Project.Feature.Features
    ]
)
