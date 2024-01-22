//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by JUNHYEOK LEE on 1/22/24.
//

import Foundation
import ProjectDescription
import ProjectDescriptionHelpers

let projectName = "PillInformation"
let organizationName = "com.junhyeok.PillInformation"
let deploymentTarget: DeploymentTargets = .iOS("14.0")
let defaultInfoPlist: [String: Plist.Value] = [
    "UILaunchStoryboardName": "LaunchScreen"
]

let settings: Settings = .settings(
    base: [
        "CODE_SIGN_IDENTITY": "",
        "CODE_SIGNING_REQUIRED": "NO",
    ],
    configurations: [
        .debug(name: .dev, xcconfig: XCConfig.Application.devApp(.dev)),
        .debug(name: .test, xcconfig: XCConfig.Application.devApp(.test)),
        .release(name: .release, xcconfig: XCConfig.Application.devApp(.release)),
        .debug(name: .dev, xcconfig: XCConfig.Application.app(.dev)),
        .debug(name: .test, xcconfig: XCConfig.Application.app(.test)),
        .release(name: .release, xcconfig: XCConfig.Application.app(.release))
    ]
)

let scripts: [TargetScript] = [
    
]

let targets: [Target] = [
    Target(
        name: projectName,
        destinations: .iOS,
        product: .app,
        productName: projectName,
        bundleId: organizationName,
        deploymentTargets: deploymentTarget,
        infoPlist: .extendingDefault(with: defaultInfoPlist),
        sources: .sources,
        resources: .resources,
        scripts: scripts,
        dependencies: [
            .project(layer: <#T##ProjectLayer#>, name: <#T##String#>)
        ]
    )
]

let schemes: [Scheme] = [
    Scheme(
        name: .,
        shared: <#T##Bool#>,
        hidden: <#T##Bool#>,
        buildAction: <#T##BuildAction?#>,
        testAction: <#T##TestAction?#>,
        runAction: <#T##RunAction?#>,
        archiveAction: <#T##ArchiveAction?#>,
        profileAction: <#T##ProfileAction?#>,
        analyzeAction: <#T##AnalyzeAction?#>
    )
]

let project: Project = .init(
    name: "Application",
    organizationName: organizationName,
    settings: settings,
    targets: targets,
    schemes: schemes
)
