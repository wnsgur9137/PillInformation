//
//  Project1.swift
//  ApplicationManifests
//
//  Created by JunHyeok Lee on 3/19/24.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project: Project = .project(
    name: "MyPage",
    product: .staticFramework,
    dependencies: [
        .Project.Feature.Data.MyPage,
        .Project.Feature.Domain.MyPage,
        .Project.Feature.Presentation.MyPage
    ],
    hasTest: true,
    hasDemoApp: true
)
