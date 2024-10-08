//
//  Project1.swift
//  ApplicationManifests
//
//  Created by JunHyeok Lee on 3/19/24.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project: Project = .project(
    name: "Search",
    product: .staticFramework,
    dependencies: [
        .Project.Feature.Data.Search,
        .Project.Feature.Domain.Search,
        .Project.Feature.Presentation.Search
    ],
    hasTest: true,
    hasDemoApp: true
)
