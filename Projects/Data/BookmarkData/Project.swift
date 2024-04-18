//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by JunHyeok Lee on 4/18/24.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project: Project = .project(
    name: "BookmarkData",
    product: .staticFramework,
    dependencies: [
        .Project.Feature.Data.Base,
        .Project.Feature.Domain.Bookmark
    ]
)
