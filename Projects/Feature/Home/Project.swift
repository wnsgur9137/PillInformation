//
//  Project1.swift
//  ApplicationManifests
//
//  Created by JunHyeok Lee on 3/19/24.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project: Project = .project(
    name: "Home",
    product: .staticFramework,
    dependencies: [
        .Project.Feature.Data.Home,
        .Project.Feature.Domain.Home,
        .Project.Feature.Presentation.Home
    ],
    hasTest: true,
    hasDemoApp: true
)
