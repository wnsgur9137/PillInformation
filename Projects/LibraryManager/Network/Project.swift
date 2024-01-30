//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by JunHyeok Lee on 1/30/24.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project: Project = .framework(name: "Network",
                                  packages: [
                                    
                                  ],
                                  dependencies: [
                                    .SwiftPM.Network.alamofire,
                                    .SwiftPM.Network.moya
                                  ],
                                  hasDemoApp: true)
