//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by JunHyeok Lee on 1/25/24.
//

import ProjectDescription
import ProjectDescriptionHelpers
import UtilityPlugin

let project = Project.staticFramework(
    name: "Infrastructures",
    dependencies: [
        TargetDependency.Project.Infrastructure.Adapter,
        TargetDependency.Project.Infrastructure.Builder,
        TargetDependency.Project.Infrastructure.NetworkInfra,
        TargetDependency.Project.Infrastructure.ReuseableView,
    ]
)
