//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by JunHyeok Lee on 4/18/24.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project: Project = .project(
    name: "Bookmark",
    product: .staticFramework,
    dependencies: [
        .Project.Feature.Data.Bookmark,
        .Project.Feature.Domain.Bookmark,
        .Project.Feature.Presentation.Bookmark
    ],
    hasTest: true,
    hasDemoApp: true
)
