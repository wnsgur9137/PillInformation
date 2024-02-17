//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by JunHyeok Lee on 2/6/24.
//

import ProjectDescription
import ProjectDescriptionHelpers
import UtilityPlugin

let project: Project = .staticFramework(
    name: "HomeDomain",
    dependencies: [
//        .Project.Data.HomeData,
        .SwiftPM.Reactive.rxSwift,
        .SwiftPM.Reactive.rxCocoa
    ]
)
