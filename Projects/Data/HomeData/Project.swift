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
    name: "HomeData",
    dependencies: [
        .Project.Infrastructure.NetworkInfra,
        .Project.LibraryManager.NetworkLibraries,
        .Project.LibraryManager.ReactiveLibraries,
        .SwiftPM.Network.alamofire,
        .SwiftPM.Network.moya,
        .SwiftPM.Reactive.rxSwift,
        .SwiftPM.Reactive.rxCocoa
    ]
)
