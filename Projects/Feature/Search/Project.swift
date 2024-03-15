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
    name: "Search",
    product: .staticFramework,
    dependencies: [
        .Project.Feature.Presentation.Search,
        .Project.Feature.Domain.Search,
        .Project.Feature.Data.Search
    ]
)
