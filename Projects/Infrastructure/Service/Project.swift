//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by JunHyeok Lee on 2/21/24.
//

import ProjectDescription
import ProjectDescriptionHelpers
import UtilityPlugin

let project = Project.staticFramework(
    name: "Service",
    dependencies: [
        .Project.Common.Common
    ]
)
