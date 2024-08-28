//
//  Project1.swift
//  ApplicationManifests
//
//  Created by JunHyeok Lee on 3/19/24.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project: Project = .project(
    name: "Alarm",
    product: .staticFramework,
    dependencies: [
        .Project.Feature.Data.Alarm,
        .Project.Feature.Domain.Alarm,
        .Project.Feature.Presentation.Alarm
    ],
    hasTest: true,
    hasDemoApp: true
)
