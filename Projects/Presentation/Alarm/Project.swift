//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by JunHyeok Lee on 1/24/24.
//

import ProjectDescription
import ProjectDescriptionHelpers
import UtilityPlugin

let project: Project = .framework(name: "Alarm",
                                   dependencies: [
                                    .Project.Common.Common,
                                    .Project.Infrastructure.Infrastructures
                                   ])
