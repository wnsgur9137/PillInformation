//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by JunHyeok Lee on 4/12/24.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project: Project = .project(
    name: "SplashData",
    product: .staticFramework,
    dependencies: [
        .Project.Feature.Data.Base,
        .Project.Feature.Domain.Splash
    ],
    hasTest: true
)
