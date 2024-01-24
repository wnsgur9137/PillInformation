//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by JunHyeok Lee on 1/24/24.
//

import ProjectDescription
import ProjectDescriptionHelpers
import UtilityPlugin

let project: Project = .framework(name: "Presentations",
                                   dependencies: [
                                    TargetDependency.Project.Presentations.Home.Package,
                                    TargetDependency.Project.Presentations.Search.Package,
                                    TargetDependency.Project.Presentations.Alarm.Package,
                                    TargetDependency.Project.Presentations.MyPage.Package
                                   ].flatMap { $0 })
