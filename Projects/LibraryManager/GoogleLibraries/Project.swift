//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by JunHyeok Lee on 4/5/24.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project: Project = .project(
    name: "GoogleLibraries",
    product: .framework,
    dependencies: [
        .SPM.Google.GoogleSignIn
    ]
)
