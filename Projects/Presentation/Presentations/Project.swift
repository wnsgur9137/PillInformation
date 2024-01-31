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
                                    TargetDependency.Project.Presentations.Home,
                                    TargetDependency.Project.Presentations.Search,
                                    TargetDependency.Project.Presentations.Alarm,
                                    TargetDependency.Project.Presentations.MyPage
                                   ] + TargetDependency.Project.LibraryManager.PresentationLibrarys
)
