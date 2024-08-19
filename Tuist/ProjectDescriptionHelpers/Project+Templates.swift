//
//  Project+Templates.swift
//  ApplicationManifests
//
//  Created by JunHyeok Lee on 3/19/24.
//

import ProjectDescription

let appVersion: Plist.Value = "0.1.2"
let bundleVersion: Plist.Value = "1"

public let defaultInfoPlist: [String: Plist.Value] = [
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
    "CFBundleShortVersionString": appVersion,
    "CFBundleVersion": bundleVersion,
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
        "MEDICINE_INFO_API_KEY": "${MEDICINE_INFO_API_KEY}",
        "IS_SHOW_ALARM_TAB": "${IS_SHOW_ALARM_TAB}",
        "IS_SHOW_ALARM_PRIVACY": "${IS_SHOW_ALARM_PRIVACY}"
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
    ],
    "UISupportedInterfaceOrientations": [
        "UIInterfaceOrientationPortrait",
        "UIInterfaceOrientationPortraitUpsideDown",
        "UIInterfaceOrientationLandscapeLeft",
        "UIInterfaceOrientationLandscapeRight"
    ],
    "UISupportedInterfaceOrientations~ipad": [
        "UIInterfaceOrientationPortrait",
        "UIInterfaceOrientationPortraitUpsideDown",
        "UIInterfaceOrientationLandscapeLeft",
        "UIInterfaceOrientationLandscapeRight"
    ],
    "NSPhotoLibraryAddUsageDescription": "Test",
    "NSLocationWhenInUseUsageDescription": "Test Test",
    "NSLocationAlwaysAndWhenInUseUsageDescription": "Test12345"
]

extension Project {
    public static func project(name: String,
                               product: Product,
                               destinations: Destinations = .iOS,
                               organizationName: String = "com.junhyeok.PillInformation",
                               settings: [String: SettingValue] = [:],
                               packages: [Package] = [],
                               deploymentTarget: DeploymentTargets? = .iOS("14.0"),
                               dependencies: [TargetDependency] = [],
                               infoPlist: [String: Plist.Value] = [:],
                               hasDemoApp: Bool = false) -> Project {
        let settings: Settings = .settings(
            base: [
                "OTHER_LDFLAGS": ["-lc++", "-Objc"],
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
        
        let target: Target = .target(
            name: name,
            destinations: destinations,
            product: product,
            bundleId: "\(organizationName).\(name)",
            deploymentTargets: deploymentTarget,
            infoPlist: .extendingDefault(with: infoPlist),
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: dependencies
        )
        
        let demoAppTarget: Target = .target(
            name: "\(name)DemoApp",
            destinations: destinations,
            product: .app,
            bundleId: "\(organizationName).\(name)DemoApp",
            deploymentTargets: deploymentTarget,
            infoPlist: .extendingDefault(with: defaultInfoPlist),
            sources: ["Demo/**"],
            resources: ["Demo/Resources/**"],
            dependencies: [.target(name: name)],
            settings: .settings(
                base: ["OTHER_LDFLAGS": ["-lc++", "-Objc"]],
                configurations: [
                    .debug(
                        name: .DEV,
                        xcconfig: .XCConfig.app(.DEV)
                    ),
                    .release(
                        name: .PROD,
                        xcconfig: .XCConfig.app(.PROD)
                    )
                ]
            )
        )
        
        let testTargetDependencies: [TargetDependency] = hasDemoApp ? [.target(name: "\(name)DemoApp")] : [.target(name: "\(name)")]
        
        let testTarget: Target = .target(
            name: "\(name)Tests",
            destinations: destinations,
            product: .unitTests,
            bundleId: "\(organizationName).\(name)Tests",
            deploymentTargets: deploymentTarget,
            infoPlist: .default,
            sources: ["Tests/**"],
            dependencies: testTargetDependencies
        )
        
        let schemes: [Scheme] = hasDemoApp
        ? [.makeScheme(target: .DEV, name: name), .makeDemoScheme(target: .DEV, name: name)]
        : [.makeScheme(target: .DEV, name: name)]
        
        let targets: [Target] = hasDemoApp
        ? [target, testTarget, demoAppTarget]
        : [target, testTarget]
        
        return Project(name: name,
                       organizationName: organizationName,
                       packages: packages,
                       settings: settings,
                       targets: targets,
                       schemes: schemes)
    }
}
