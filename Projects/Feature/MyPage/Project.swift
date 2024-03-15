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
    name: "MyPage",
    product: .staticFramework,
    dependencies: [
        .Project.Feature.Presentation.MyPage,
        .Project.Feature.Domain.MyPage,
        .Project.Feature.Data.MyPage
    ]
)
