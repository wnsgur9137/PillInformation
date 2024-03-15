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
    name: "Home",
    product: .staticFramework,
    dependencies: [
        .Project.Feature.Presentation.Home,
        .Project.Feature.Domain.Home,
        .Project.Feature.Data.Home
    ]
)