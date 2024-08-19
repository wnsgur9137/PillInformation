//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by JunHyeok Lee on 4/1/24.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project: Project = .project(
    name: "DataLibraries",
    product: .staticFramework,
    dependencies: [
        .SPM.Data.RealmSwift
    ]
)
