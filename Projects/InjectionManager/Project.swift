//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by JunHyoek Lee on 8/21/24.
//

import Foundation

import ProjectDescription
import ProjectDescriptionHelpers

let project: Project = .project(
    name: "InjectionManager",
    product: .staticFramework,
    dependencies: [
        .Project.Infrastructure.Network,
        .Project.Infrastructure.Notification,
        .Project.Feature.Features
    ]
)
