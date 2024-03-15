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
    name: "NetworkLibraries",
    product: .framework,
    dependencies: [
        .SwiftPM.Network.Alamofire,
        .SwiftPM.Network.Moya
    ]
)
