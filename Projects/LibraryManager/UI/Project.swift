//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by JunHyeok Lee on 1/30/24.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project: Project = .framework(name: "UI",
                                  packages: [
                                    
                                  ],
                                  dependencies: [
                                    .SwiftPM.UI.skeletonView,
                                    .SwiftPM.UI.kingFisher,
                                  ],
                                  hasDemoApp: true)
