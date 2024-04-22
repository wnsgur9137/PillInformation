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
        "KAKAO_NATIVE_APP_KEY": "${KAKAO_NATIVE_APP_KEY}",
        "API_BASE_URL": "${API_BASE_URL}",
        "MEDICINE_API_URL": "${MEDICINE_API_URL}",
        "MEDICINE_API_KEY": "${MEDICINE_KEY}",
        "MEDICINE_INFO_API_URL": "${MEDICINE_INFO_API_URL}",
        "MEDICINE_INFO_API_KEY": "${MEDICINE_INFO_API_KEY}"
    ],
    "NSAppTransportSecurity": [
        "NSAllowsArbitraryLoads": true
    ],
    "LSApplicationQueriesSchemes": [
        "kakaokompassauth",
        "kakaolink"
    ],
    "CFBundleURLTypes": [
        [
            "CFBundleTypeRole": "Editor",
            "CFBundleURLSchemes": [
                "kakao\(String.kakaoNativeAppKey)",
                "kakao\(String.devKakaoNativeAppKey)"
            ]
        ]
    ]
]

// MARK: - Settings
let settings: Settings = .settings(
    base: [
        "DEVELOPMENT_TEAM": "VW2UR5Y845"
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
            .Project.InjectionManager.Infrastructure
        ],
        settings: .settings(
            base: ["OTHER_LDFLAGS": ["-lc++", "-Objc"]],
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
            base: ["OTHER_LDFLAGS": ["-lc++", "-Objc"]],
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
    settings: settings,
    targets: targets,
    schemes: schemes,
    additionalFiles: [
        "//XCConfig/Application/Application-\(AppConfiguration.SHARED).xcconfig"
    ]
)
