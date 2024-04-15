//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by JunHyeok Lee on 4/12/24.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project: Project = .project(
    name: "Loading",
    product: .staticFramework,
    dependencies: [
        .Project.Feature.Data.Loading,
        .Project.Feature.Domain.Loading,
        .Project.Feature.Presentation.Loading
    ]
)
