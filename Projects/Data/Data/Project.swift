//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by JunHyeok Lee on 1/25/24.
//

import ProjectDescription
import ProjectDescriptionHelpers
import UtilityPlugin

let project: Project = .staticFramework(
    name: "Data",
    dependencies: [
        .Project.Data.HomeData,
        .Project.Data.SearchData,
        .Project.Data.AlarmData,
        .Project.Data.MyPageData
    ]
)
