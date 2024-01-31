//
//  Dependencies.swift
//  Config
//
//  Created by JunHyeok Lee on 1/31/24.
//

import ProjectDescription
import ProjectDescriptionHelpers

let dependencies = Dependencies(
    carthage: [
        .github(path: "layoutBox/FlexLayout", requirement: .branch("master")),
        .github(path: "layoutBox/PinLayout", requirement: .branch("master"))
    ],
    platforms: [.iOS]
)
