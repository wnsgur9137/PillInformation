//
//  Project1.swift
//  ApplicationManifests
//
//  Created by JunHyeok Lee on 3/19/24.
//

import ProjectDescription
import ProjectDescriptionHelpers

let projectName = "PillInformation"

let organizationName = "com.junhyeok.PillInformation"

let deploymentTargets: DeploymentTargets = .iOS("14.0")

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
//    base: [
//        "OTHER_LDFLAGS": ["-lc++", "-Objc"]
//    ],
    configurations: [
        .debug(name: .DEV),
        .debug(name: .TEST_DEV),
        .debug(name: .TEST_PROD),
        .release(name: .PROD)
    ],
    defaultSettings: .recommended
)

// MARK: - Scripts
let scripts: [TargetScript] = []

// MARK: - Targets
let targets: [Target] = [
    .target(
        name: projectName,
        destinations: .iOS,
        product: .app,
        productName: projectName,
        bundleId: organizationName,
        deploymentTargets: deploymentTargets,
        infoPlist: .extendingDefault(with: defaultInfoPlist),
        sources: ["Sources/**"],
        resources: ["Resources/**"],
        scripts: scripts,
        dependencies: [
            .Project.Feature.Features,
            .Project.InjectionManager.Infrastructure
        ],
        settings: .settings(
            base: ["OTHER_LDFLAGS": ["-lc++", "-Objc"]],
            configurations: [
                .debug(
                    name: .DEV,
                    settings: [
                        "ASSETCATALOG_COMPILER_APPICON_NAME": "AppIconDevServer"
                    ],
                    xcconfig: .XCConfig.app(.DEV)
                ),
                .release(
                    name: .PROD,
                    settings: [
                        "SWIFT_ACTIVE_COMPILATION_CONDITIONS": "RELEASE",
                        "ASSETCATALOG_COMPILER_APPICON_NAME": "AppIcon"
                    ],
                    xcconfig: .XCConfig.app(.PROD)
                )
            ]
        )
    ),
    .target(
        name: "\(projectName)Tests",
        destinations: .iOS,
        product: .unitTests,
        productName: "\(projectName)Tests",
        bundleId: "\(organizationName)Tests",
        deploymentTargets: deploymentTargets,
        infoPlist: .default,
        sources: ["Tests/**"],
        dependencies: [
            .target(name: projectName)
        ],
        settings: .settings(
            base: ["OTHER_LDFLAGS": ["-lc++", "-Objc"]],
            configurations: [
                .debug(
                    name: .TEST_DEV,
//                    settings: [
//                        "OTHER_LDFLAGS": "$(inherited) -Xlinker -interposable -all_load"
//                    ],
                    xcconfig: .XCConfig.app(.TEST_DEV)
                ),
                .debug(
                    name: .TEST_PROD,
//                    settings: [
//                        "OTHER_LDFLAGS": "$(inherited) -Xlinker -interposable -all_load"
//                    ],
                    xcconfig: .XCConfig.app(.TEST_PROD)
                ),
            ]
        )
    )
]

// MARK: - Schemes
let schemes: [Scheme] = [
    
]

// MARK: - Project
let project: Project = .init(
    name: "Application",
    organizationName: organizationName,
    settings: settings,
    targets: targets,
    schemes: schemes,
    additionalFiles: [
        "//XCConfig/Application/Application-\(AppConfiguration.SHARED).xcconfig"
    ]
)
