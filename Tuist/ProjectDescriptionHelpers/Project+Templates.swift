import ProjectDescription
import UtilityPlugin

extension Project {
    public static func staticLibrary(name: String,
                                     destinations: Destinations = .iOS,
                                     packages: [Package] = [],
                                     dependencies: [TargetDependency] = [],
                                     hasDemoApp: Bool = false) -> Self {
        return project(name: name,
                       destinations: destinations,
                       packages: packages,
                       product: .staticLibrary,
                       dependencies: dependencies,
                       hasDemoApp: hasDemoApp)
    }
    
    public static func staticFramework(name: String,
                                       destinations: Destinations = .iOS,
                                       packages: [Package] = [],
                                       dependencies: [TargetDependency] = [],
                                       hasDemoApp: Bool = false) -> Self {
        return project(name: name,
                       destinations: destinations,
                       packages: packages,
                       product: .staticFramework,
                       dependencies: dependencies,
                       hasDemoApp: hasDemoApp)
    }
    
    public static func framework(name: String,
                                 destinations: Destinations = .iOS,
                                 packages: [Package] = [],
                                 dependencies: [TargetDependency] = [],
                                 hasDemoApp: Bool = false) -> Self {
        return project(name: name,
                       destinations: destinations,
                       packages: packages,
                       product: .framework,
                       dependencies: dependencies,
                       hasDemoApp: hasDemoApp)
    }
}

extension Project {
    public static func project(name: String,
                               destinations: Destinations = .iOS,
                               organizationName: String = "com.junhyeok.PillInformation",
                               packages: [Package] = [],
                               product: Product,
                               deploymentTarget: DeploymentTargets? = .iOS("14.0"),
                               dependencies: [TargetDependency] = [],
                               infoPlist: [String: Plist.Value] = [:],
                               hasDemoApp: Bool = false) -> Project {
        let settings: Settings = .settings(base: ["CODE_SIGN_IDENTITY": "",
                                                  "CODE_SIGNING_REQUIRED": "NO"],
                                           configurations: [
                                            .debug(name: .dev, settings: [
                                                "GCC_PREPROCESSOR_DEFINITIONS": ["DEBUG=1", "OTHER_MACRO=1", "FLEXLAYOUT_SWIFT_PACKAGE=1"],
//                                                "OTHER_LDFLAGS": "$(inherited) -all_load"
                                            ], xcconfig: .relativeToXCConfig(.dev)),
                                            .debug(name: .test, settings: ["GCC_PREPROCESSOR_DEFINITIONS": ["DEBUG=1", "OTHER_MACRO=1", "FLEXLAYOUT_SWIFT_PACKAGE=1"]], xcconfig: .relativeToXCConfig(.test)),
                                            .release(name: .prod, settings: ["GCC_PREPROCESSOR_DEFINITIONS": ["RELEASE=1", "FLEXLAYOUT_SWIFT_PACKAGE=1"]], xcconfig: .relativeToXCConfig(.prod))
                                           ])
        let target = Target(name: name,
                            destinations: destinations,
                            product: product,
                            productName: name,
                            bundleId: "com.junhyeok.\(name)",
                            deploymentTargets: deploymentTarget,
                            infoPlist: .extendingDefault(with: infoPlist),
                            sources: ["Sources/**"],
                            resources: ["Resources/**"],
                            dependencies: dependencies)
        
        let demoAppTarget = Target(name: "\(name)DemoApp",
                                   destinations: destinations,
                                   product: .app,
                                   productName: name,
                                   bundleId: "com.junhyeok.\(name)DemoApp",
                                   deploymentTargets: deploymentTarget,
                                   infoPlist: .extendingDefault(with: [
                                    "UILaunchStoryboardName": "LaunchScreen"
                                   ]),
                                   sources: ["Demo/**"],
                                   resources: ["Demo/Resources/**"],
                                   dependencies: [
                                    .target(name: "\(name)")
                                   ])
        
        let testTargetDependencies: [TargetDependency] = hasDemoApp
            ? [.target(name: "\(name)DemoApp")]
            : [.target(name: "\(name)")]
        
        let testTarget = Target(name: "\(name)Tests",
                                destinations: destinations,
                                product: .unitTests,
                                bundleId: "com.junhyeok.\(name)Tests",
                                deploymentTargets: deploymentTarget,
                                infoPlist: .default,
                                sources: "Tests/**",
                                dependencies: testTargetDependencies)
        
        let schemes: [Scheme] = hasDemoApp
            ? [.makeScheme(target: .dev, name: name), .makeDemoScheme(target: .dev, name: name)]
            : [.makeScheme(target: .dev, name: name)]
        
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

extension Scheme {
    static func makeScheme(target: AppConfiguration, name: String) -> Self {
        return Scheme(name: "\(name)",
                      shared: true,
                      buildAction: .buildAction(targets: ["\(name)"]),
                      testAction: .targets(["\(name)Tests"],
                                           arguments: nil,
                                           configuration: target.configurationName,
                                           options: .options(coverage: true)),
                      runAction: .runAction(configuration: target.configurationName),
                      archiveAction: .archiveAction(configuration: target.configurationName),
                      profileAction: .profileAction(configuration: target.configurationName),
                      analyzeAction: .analyzeAction(configuration: target.configurationName))
    }

    static func makeDemoScheme(target: AppConfiguration, name: String) -> Self {
        return Scheme(name: "\(name)DemoApp",
                      shared: true,
                      buildAction: .buildAction(targets: ["\(name)DemoApp"]),
                      testAction: .targets(["\(name)Tests"],
                                           arguments: nil,
                                           configuration: target.configurationName,
                                           options: .options(coverage: true)),
                      runAction: .runAction(configuration: target.configurationName),
                      archiveAction: .archiveAction(configuration: target.configurationName),
                      profileAction: .profileAction(configuration: target.configurationName),
                      analyzeAction: .analyzeAction(configuration: target.configurationName))
        
    }
}
