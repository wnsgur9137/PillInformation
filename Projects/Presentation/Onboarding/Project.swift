//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by JunHyeok Lee on 2/27/24.
//

import ProjectDescription
import ProjectDescriptionHelpers
import UtilityPlugin

let project: Project = .framework(
    name: "Onboarding",
    dependencies: [
        .Project.Common.Common,
        .Project.Domain.AlarmDomain
    ] + TargetDependency.Project.Infrastructure.All
)
