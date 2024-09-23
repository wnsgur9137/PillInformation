//
//  Project1.swift
//  ApplicationManifests
//
//  Created by JunHyeok Lee on 3/19/24.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project: Project = .project(
    name: "ReactiveLibraries",
    product: .framework,
    dependencies: [
        .SPM.Reactive.ReactorKit,
        .SPM.Reactive.RxSwift,
    ]
)
