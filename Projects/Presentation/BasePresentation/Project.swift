//
//  Project1.swift
//  ApplicationManifests
//
//  Created by JunHyeok Lee on 3/19/24.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project: Project = .project(
    name: "BasePresentation",
    product: .staticFramework,
    dependencies: [
        .Project.LibraryManager.ReactiveLibraries,
        .Project.LibraryManager.KakaoLibraries,
        .Project.LibraryManager.LayoutLibraries,
        .Project.LibraryManager.UILibraries,
        .Project.Infrastructure.Notification,
    ]
)
