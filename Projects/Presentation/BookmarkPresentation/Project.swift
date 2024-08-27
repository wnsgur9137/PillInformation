//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by JunHyeok Lee on 4/18/24.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project: Project = .project(
    name: "BookmarkPresentation",
    product: .staticFramework,
    dependencies: [
        .Project.Feature.Presentation.Base
    ],
    hasTest: true
)
