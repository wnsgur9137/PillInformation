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
    name: "AlarmData",
    product: .staticFramework,
    dependencies: [
        .Project.Feature.Domain.Alarm
    ]
)
