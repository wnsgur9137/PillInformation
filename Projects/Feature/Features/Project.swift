//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by JunHyeok Lee on 3/15/24.
//

import ProjectDescription
import ProjectDescriptionHelpers
import UtilityPlugin

let project: Project = .project(
    name: "Features",
    product: .framework,
    dependencies: [
        .Project.Feature.Onboarding,
        .Project.Feature.Home,
        .Project.Feature.Search,
        .Project.Feature.Alarm,
        .Project.Feature.MyPage
    ]
)

