//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by JunHyeok Lee on 1/25/24.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.staticFramework(
    name: "ReuseableView",
    dependencies: [
        .Project.Common.Common
    ] + TargetDependency.SwiftPM.presentationPackage
)
