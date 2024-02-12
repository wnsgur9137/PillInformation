//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by JunHyeok Lee on 1/24/24.
//

import ProjectDescription
import ProjectDescriptionHelpers
import UtilityPlugin

let project:Project = .staticFramework(
    name: "Domains",
    dependencies: [
        .Project.Domain.HomeDomain,
        .Project.Domain.SearchDomain,
        .Project.Domain.AlarmDomain,
        .Project.Domain.MyPageDomain
    ]
)
