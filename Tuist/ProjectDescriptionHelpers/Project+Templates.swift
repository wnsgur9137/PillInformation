//
//  Project+Templates.swift
//  ApplicationManifests
//
//  Created by JunHyeok Lee on 3/19/24.
//

import ProjectDescription

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
                "OTHER_LDFLAGS": ["-lc++", "-Objc"]
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
            infoPlist: .extendingDefault(with: [
                "UILaunchStoryboardName": "LaunchScreen"
            ]),
            sources: ["Demo/**"],
            resources: ["Demo/Resources/**"],
            dependencies: [.target(name: name)]
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
