//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by JunHyeok Lee on 1/24/24.
//

import ProjectDescription
import ProjectDescriptionHelpers
import UtilityPlugin

let project: Project = .framework(
    name: "BaseTab",
    dependencies: [
        .Project.Presentations.Home,
        .Project.Presentations.Search,
        .Project.Presentations.Alarm,
        .Project.Presentations.MyPage,
        .Project.Common.Common,
    ] + TargetDependency.Project.Infrastructure.All
)
