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

// MARK: - Settings
let settings: Settings = .settings(
    base: [
        "DEVELOPMENT_TEAM": "VW2UR5Y845",
        "GCC_PREPROCESSOR_DEFINITIONS": ["FLEXLAYOUT_SWIFT_PACKAGE=1"]
    ],
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
        entitlements: "../../SupportingFiles/PillInformation.entitlements",
        scripts: scripts,
        dependencies: [
            .Project.Feature.Features,
            .Project.InjectionManager.InjectionManager
        ],
        settings: .settings(
            base: [
                "OTHER_LDFLAGS": ["-lc++", "-Objc"],
                "GCC_PREPROCESSOR_DEFINITIONS": ["FLEXLAYOUT_SWIFT_PACKAGE=1"]
            ],
            configurations: [
                .debug(
                    name: .DEV,
                    settings: [
                        "ASSETCATALOG_COMPILER_APPICON_NAME": "AppIconDevServer",
                        "PRODUCT_BUNDLE_IDENTIFIER": "\(organizationName)-Dev",
                        "PRODUCT_NAME": "PillInformation-Dev"
                    ],
                    xcconfig: .XCConfig.app(.DEV)
                ),
                .release(
                    name: .PROD,
                    settings: [
                        "SWIFT_ACTIVE_COMPILATION_CONDITIONS": "RELEASE",
                        "ASSETCATALOG_COMPILER_APPICON_NAME": "AppIcon",
                        "PRODUCT_BUNDLE_IDENTIFIER": "\(organizationName)",
                        "PRODUCT_NAME": "PillInformation"
                    ],
                    xcconfig: .XCConfig.app(.PROD)
                )
            ]
        ),
        launchArguments: [
            .launchArgument(name: "IDEPreferLogStreaming", isEnabled: true)
        ]
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
        entitlements: "../../SupportingFiles/PillInformation.entitlements",
        dependencies: [
            .target(name: projectName)
        ],
        settings: .settings(
            base: [
                "OTHER_LDFLAGS": ["-lc++", "-Objc"],
                "GCC_PREPROCESSOR_DEFINITIONS": ["FLEXLAYOUT_SWIFT_PACKAGE=1"]
            ],
            configurations: [
                .debug(
                    name: .TEST_DEV,
                    settings: [
                        "ASSETCATALOG_COMPILER_APPICON_NAME": "AppIconDevServer",
                        "PRODUCT_BUNDLE_IDENTIFIER": "\(organizationName)Tests-Dev",
                        "PRODUCT_NAME": "PillInformationTests-Dev"
                    ],
                    xcconfig: .XCConfig.app(.TEST_DEV)
                ),
                .debug(
                    name: .TEST_PROD,
                    settings: [
                        "ASSETCATALOG_COMPILER_APPICON_NAME": "AppIconDevServer",
                        "PRODUCT_BUNDLE_IDENTIFIER": "\(organizationName)Tests",
                        "PRODUCT_NAME": "PillInformationTests"
                    ],
                    xcconfig: .XCConfig.app(.TEST_PROD)
                ),
            ]
        ),
        launchArguments: [
            .launchArgument(name: "IDEPreferLogStreaming", isEnabled: true)
        ]
    )
]

// MARK: - Schemes
let schemes: [Scheme] = [
    
]

// MARK: - Project
let project: Project = .init(
    name: "Application",
    organizationName: organizationName,
    options: .options(
        defaultKnownRegions: ["en", "ko"],
        developmentRegion: "ko"
    ),
    settings: settings,
    targets: targets,
    schemes: schemes,
    additionalFiles: [
        "//XCConfig/Application/Application-\(AppConfiguration.SHARED).xcconfig"
    ]
)
