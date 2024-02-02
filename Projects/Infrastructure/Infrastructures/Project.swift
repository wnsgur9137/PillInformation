//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by JunHyeok Lee on 1/25/24.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.staticFramework(
    name: "Infrastructures",
    dependencies: [
        TargetDependency.Project.Infrastructure.Adapter.Package,
        TargetDependency.Project.Infrastructure.Builder.Package,
        TargetDependency.Project.Infrastructure.NetworkInfra.Package,
        TargetDependency.Project.Infrastructure.ReuseableView.Package,
    ].flatMap{ $0 }
)
