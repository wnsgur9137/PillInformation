//
//  Project1.swift
//  ApplicationManifests
//
//  Created by JunHyeok Lee on 3/19/24.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project: Project = .project(
    name: "NetworkInfra",
    product: .framework,
    dependencies: [
        .Project.LibraryManager.ReactiveLibraries,
        .Project.LibraryManager.NetworkLibraries
    ],
    hasTest: true
)
