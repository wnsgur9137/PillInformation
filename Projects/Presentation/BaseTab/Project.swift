//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by JunHyeok Lee on 1/24/24.
//

import ProjectDescription
import ProjectDescriptionHelpers
import UtilityPlugin

let project: Project = .framework(name: "BaseTab",
                                   dependencies: [
                                    TargetDependency.Project.Common.Common,
                                    TargetDependency.Project.Infrastructure.Infrastructures,
                                    TargetDependency.Project.Presentations.Presentations
                                   ])
