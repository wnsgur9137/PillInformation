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
    ],
    "UIAppFonts": [
        "SUITE-Bold.otf",
        "SUITE-ExtraBold.otf",
        "SUITE-Heavy.otf",
        "SUITE-Light.otf",
        "SUITE-Medium.otf",
        "SUITE-Regular.otf",
        "SUITE-SemiBold.otf"
    ],
    "AppConfigurations": [
        "API_BASE_URL": "${API_BASE_URL}",
        "MEDICINE_API_URL": "${MEDICINE_API_URL}",
        "MEDICINE_API_KEY": "${MEDICINE_KEY}",
        "MEDICINE_INFO_API_URL": "${MEDICINE_INFO_API_URL}",
        "MEDICINE_INFO_API_KEY": "${MEDICINE_INFO_API_KEY}"
    ],
    "NSAppTransportSecurity": [
        "NSAllowsArbitraryLoads": true
    ]
]

// MARK: - Settings
let settings: Settings = .settings(
    base: [
        "CODE_SIGN_IDENTITY": "",
        "CODE_SIGNING_REQUIRED": "NO",
    ],
    configurations: [
        .debug(name: .dev),
        .debug(name: .test),
        .release(name: .prod),
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
            .Project.BaseTab
           ],
           settings: .settings(configurations: [
            .debug(name: .dev, 
                   settings: [
                    "ASSETCATALOG_COMPILER_APPICON_NAME": "AppIconDevServer"
                   ],
                   xcconfig: XCConfig.Application.app(.dev)),
            .release(name: .prod, 
                     settings: [
                        "SWIFT_ACTIVE_COMPILATION_CONDITIONS": "RELEASE",
                        "ASSETCATALOG_COMPILER_APPICON_NAME": "AppIcon"
                     ],
                     xcconfig: XCConfig.Application.app(.prod))
           ])
          ),
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
            .Project.BaseTab
           ],
           settings: .settings(configurations: [
            .debug(name: .dev, 
                   settings: [
                    "ASSETCATALOG_COMPILER_APPICON_NAME": "DevAppIconDevServer"
                   ],
                   xcconfig: XCConfig.Application.devApp(.dev)),
            .release(name: .prod,
                     settings: [
                        "SWIFT_ACTIVE_COMPILATION_CONDITIONS": "RELEASE",
                        "ASSETCATALOG_COMPILER_APPICON_NAME": "DevAppIcon"
                     ],
                     xcconfig: XCConfig.Application.devApp(.prod)),
           ])
          ),
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
           ], 
           settings: .settings(configurations: [
            .debug(name: .test, 
                   settings: ["OTHER_LDFLAGS": "$(inherited) -Xlinker -interposable -all_load"], 
                   xcconfig: XCConfig.Application.devApp(.test)),
            .debug(name: .test,
                   settings: ["OTHER_LDFLAGS": "$(inherited) -Xlinker -interposable -all_load"],
                   xcconfig: XCConfig.Application.app(.test)),
           ])
          )
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
    schemes: schemes,
    additionalFiles: [
        "//XCConfig/Application/Application-\(AppConfiguration.shared).xcconfig"
    ]
)
