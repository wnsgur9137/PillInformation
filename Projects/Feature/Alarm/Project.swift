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
    name: "Alarm",
    product: .staticFramework,
    dependencies: [
        .Project.Feature.Presentation.Alarm,
        .Project.Feature.Domain.Alarm,
        .Project.Feature.Data.Alarm
    ]
)
