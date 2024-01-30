//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by JunHyeok Lee on 1/30/24.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project: Project = .framework(name: "Reactive",
                                  packages: [
                                  ],
                                  dependencies: [
                                    .SwiftPM.Reactive.rxSwift,
                                    .SwiftPM.Reactive.rxCocoa,
                                    .SwiftPM.Reactive.rxGesture
                                  ])
