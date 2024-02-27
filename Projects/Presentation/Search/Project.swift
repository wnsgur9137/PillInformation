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
    name: "Search",
    dependencies: [
        .Project.Common.Common,
        .Project.Domain.SearchDomain
    ] + TargetDependency.SwiftPM.presentationPackage
    + TargetDependency.Project.Infrastructure.All
)
