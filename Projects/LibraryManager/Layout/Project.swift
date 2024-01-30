//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by JunHyeok Lee on 1/30/24.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project: Project = .framework(name: "Layout",
                                  packages: [
                                    
                                  ],
                                  dependencies: [
                                    .SwiftPM.Layout.flexLayout,
                                    .SwiftPM.Layout.pinLayout
                                  ],
                                  hasDemoApp: true)
