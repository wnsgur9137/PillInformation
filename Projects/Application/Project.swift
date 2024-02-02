//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by JUNHYEOK LEE on 1/22/24.
//

import Foundation
import ProjectDescription
import ProjectDescriptionHelpers
import UtilityPlugin

let projectName = "PillInformation"
let organizationName = "com.junhyeok.PillInformation"
let deploymentTarget: DeploymentTargets = .iOS("14.0")
let defaultInfoPlist: [String: Plist.Value] = [
    "UILaunchStoryboardName": "LaunchScreen",
    "UIApplicationSceneManifest": [
        "UIApplicationSupportsMultipleScenes": false,
        "UISceneConfigurations": [
            "UIWindowSceneSessionRoleApplication": [
                [
                    "UISceneConfigurationName": "Default Configuration",
                    "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate"
                ]
            ]
        ]
    ]
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
        .release(name: .prod, xcconfig: XCConfig.Application.devApp(.prod)),
        .debug(name: .dev, xcconfig: XCConfig.Application.app(.dev)),
        .debug(name: .test, xcconfig: XCConfig.Application.app(.test)),
        .release(name: .prod, xcconfig: XCConfig.Application.app(.prod))
    ]
)

// MARK: - Scripts
let scripts: [TargetScript] = [
    
]

// MARK: - Targets
let targets: [Target] = [
    Target(name: projectName,
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
            .Project.Presentations.BaseTab,
           ] + TargetDependency.SwiftPM.all),
    Target(name: "\(projectName)_DevApp",
           destinations: .iOS,
           product: .app,
           productName: "\(projectName)_DevApp",
           bundleId: "com.junhyeok.dev-PillInformation",
           deploymentTargets: deploymentTarget,
           infoPlist: .extendingDefault(with: defaultInfoPlist),
           sources: ["Sources/**", "DevSources"],
           resources: ["Resources/**"],
           scripts: scripts,
           dependencies: [
            .Project.Presentations.BaseTab,
           ] + TargetDependency.SwiftPM.all),
    Target(name: "\(projectName)_DevAppTests",
           destinations: .iOS,
           product: .unitTests,
           productName: "\(projectName)_DevAppTests",
           bundleId: "com.junhyeok.dev-PillInformationTests",
           deploymentTargets: deploymentTarget,
           infoPlist: .default,
           sources: "Tests/**",
           dependencies: [
            .target(name: "\(projectName)_DevApp"),
           ])
]

// MARK: - Schemes
let schemes: [Scheme] = [
    Scheme(
        name: "\(projectName)_DevApp-Prod",
        shared: true,
        buildAction: .buildAction(targets: ["\(projectName)"]),
        testAction: nil,
        runAction: .runAction(configuration: .prod),
        archiveAction: .archiveAction(configuration: .prod),
        profileAction: .profileAction(configuration: .prod),
        analyzeAction: .analyzeAction(configuration: .prod)
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
