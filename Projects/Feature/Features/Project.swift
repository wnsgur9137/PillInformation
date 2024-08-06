//
//  Project1.swift
//  ApplicationManifests
//
//  Created by JunHyeok Lee on 3/19/24.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project: Project = .project(
    name: "Features",
    product: .framework,
    dependencies: [
        .Project.Feature.Splash,
        .Project.Feature.Onboarding,
        .Project.Feature.Home,
        .Project.Feature.Bookmark,
        .Project.Feature.Alarm,
        .Project.Feature.Search,
        .Project.Feature.MyPage,
        .Project.Feature.Health
    ]
)
