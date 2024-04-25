//
//  Project1.swift
//  ApplicationManifests
//
//  Created by JunHyeok Lee on 3/19/24.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project: Project = .project(
    name: "UILibraries",
    product: .framework,
    dependencies: [
        .SPM.UI.DropDown,
        .SPM.UI.KingFisher,
        .SPM.UI.SkeletonView,
        .SPM.UI.Lottie,
        .SPM.UI.Tabman,
        .SPM.UI.IQKeyboardManager
    ]
)
