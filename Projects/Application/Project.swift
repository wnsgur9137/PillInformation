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

// MARK: - Settings
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

// MARK: - Scripts
let scripts: [TargetScript] = [
    
]

// MARK: - Targets
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
            .Project.Presentations.Presentations
        ]
    )
]

// MARK: - Schemes
let schemes: [Scheme] = [
    Scheme(
        name: "\(projectName)_DevApp-Release",
        shared: true,
        buildAction: .buildAction(targets: ["\(projectName)"]),
        testAction: nil,
        runAction: .runAction(configuration: .release),
        archiveAction: .archiveAction(configuration: .release),
        profileAction: .profileAction(configuration: .release),
        analyzeAction: .analyzeAction(configuration: .release)
    ),
    Scheme(
        name: "\(projectName)_DevApp-Develop",
        shared: true,
        buildAction: .buildAction(targets: ["\(projectName)_DevApp"]),
        testAction: .targets(
            ["\(projectName)_DevAppTests"],
            configuration: .dev,
            options: .options(coverage: true)
        ),
        runAction: .runAction(configuration: .dev),
        archiveAction: .archiveAction(configuration: .dev),
        profileAction: .profileAction(configuration: .dev),
        analyzeAction: .analyzeAction(configuration: .dev)
    )
]

// MARK: - Project
let project: Project = .init(
    name: "Application",
    organizationName: organizationName,
    settings: settings,
    targets: targets,
    schemes: schemes
)
