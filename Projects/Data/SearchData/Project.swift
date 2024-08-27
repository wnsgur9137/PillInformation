//
//  Project1.swift
//  ApplicationManifests
//
//  Created by JunHyeok Lee on 3/19/24.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project: Project = .project(
    name: "SearchData",
    product: .staticFramework,
    dependencies: [
        .Project.Feature.Data.Base,
        .Project.Feature.Domain.Search
    ],
    hasTest: true
)
