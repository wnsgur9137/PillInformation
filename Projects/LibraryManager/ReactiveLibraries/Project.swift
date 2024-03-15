//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by JunHyeok Lee on 1/31/24.
//

import ProjectDescription
import ProjectDescriptionHelpers
import UtilityPlugin

let project: Project = .project(
    name: "ReactiveLibraries",
    product: .framework,
    dependencies: [
        .SwiftPM.Reactive.ReactorKit,
        .SwiftPM.Reactive.RxSwift,
        .SwiftPM.Reactive.RxCocoa,
        .SwiftPM.Reactive.RxGesture
    ]
)
