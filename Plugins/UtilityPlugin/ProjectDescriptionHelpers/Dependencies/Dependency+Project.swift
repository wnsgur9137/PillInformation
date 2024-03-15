//
//  Dependency.swift
//  ProjectDescriptionHelpers
//
//  Created by JUNHYEOK LEE on 1/22/24.
//

import Foundation
import ProjectDescription

public enum ProjectLayer: String {
    case Application
    case InjectionManager
    case Feature
    case Presentation
    case Domain
    case Data
    case Infrastructure
    case LibraryManager
}

// MARK: - Projects
extension TargetDependency {
    public struct Project {
        public struct InjectionManager { }
        public struct Feature {
            public struct Presentation { }
            public struct Domain { }
            public struct Data { }
        }
        public struct Infrastructure { }
        public struct LibraryManager { }
    }
}

// MARK: - Project
public extension TargetDependency.Project {
    static let BaseTab: TargetDependency = .project(target: "BaseTab", path: .relativeToProject(name: "BaseTab"))
    static let Common: TargetDependency = .project(target: "Common", path: .relativeToProject(name: "Common"))
}

// MARK: - Feature
public extension TargetDependency.Project.Feature {
    static let Features: TargetDependency = .project(layer: .Feature, name: "Features")
    static let Onboarding: TargetDependency = .project(layer: .Feature, name: "Onboarding")
    static let Home: TargetDependency = .project(layer: .Feature, name: "Home")
    static let Search: TargetDependency = .project(layer: .Feature, name: "Search")
    static let Alarm: TargetDependency = .project(layer: .Feature, name: "Alarm")
    static let MyPage: TargetDependency = .project(layer: .Feature, name: "MyPage")
}

// MARK: - Presentation
public extension TargetDependency.Project.Feature.Presentation {
    static let Onboarding: TargetDependency = .project(layer: .Presentation, name: "OnboardingPresentation")
    static let Home: TargetDependency = .project(layer: .Presentation, name: "HomePresentation")
    static let Search: TargetDependency = .project(layer: .Presentation, name: "SearchPresentation")
    static let Alarm: TargetDependency = .project(layer: .Presentation, name: "AlarmPresentation")
    static let MyPage: TargetDependency = .project(layer: .Presentation, name: "MyPagePresentation")
}

// MARK: - Domain
public extension TargetDependency.Project.Feature.Domain {
    static let Onboarding: TargetDependency = .project(layer: .Domain, name: "OnboardingDomain")
    static let Home: TargetDependency = .project(layer: .Domain, name: "HomeDomain")
    static let Search: TargetDependency = .project(layer: .Domain, name: "SearchDomain")
    static let Alarm: TargetDependency = .project(layer: .Domain, name: "AlarmDomain")
    static let MyPage: TargetDependency = .project(layer: .Domain, name: "MyPageDomain")
}

// MARK: - Data
public extension TargetDependency.Project.Feature.Data {
    static let Onboarding: TargetDependency = .project(layer: .Data, name: "OnboardingData")
    static let Home: TargetDependency = .project(layer: .Data, name: "HomeData")
    static let Search: TargetDependency = .project(layer: .Data, name: "SearchData")
    static let Alarm: TargetDependency = .project(layer: .Data, name: "AlarmData")
    static let MyPage: TargetDependency = .project(layer: .Data, name: "MyPageData")
}

// MARK: - Infrastructure
public extension TargetDependency.Project.Infrastructure {
    static let NetworkInfra: TargetDependency = .project(layer: .Infrastructure, name: "NetworkInfra")
    static let ReuseableView: TargetDependency = .project(layer: .Infrastructure, name: "ReuseableView")
    static let Service: TargetDependency = .project(layer: .Infrastructure, name: "Service")
}

// MARK: - LibraryManager
public extension TargetDependency.Project.LibraryManager {
    static let NetworkLibraries: TargetDependency = .project(layer: .LibraryManager, name: "NetworkLibraries")
    static let ReactiveLibraries: TargetDependency = .project(layer: .LibraryManager, name: "ReactiveLibraries")
    static let LayoutLibraries: TargetDependency = .project(layer: .LibraryManager, name: "LayoutLibraries")
    static let UILibraries: TargetDependency = .project(layer: .LibraryManager, name: "UILibraries")
}

// MARK: - TargetDependency
public extension TargetDependency {
    static func project(layer: ProjectLayer) -> Self {
        return .project(target: layer.rawValue, path: .relative(to: layer))
    }
    static func project(layer: ProjectLayer, name: String) -> Self {
        return .project(target: name, path: .relative(to: layer, name: name))
    }
    static func project(name: String) -> Self {
        return .project(target: name, path: .relativeToProject(name: name))
    }
}

// MARK: - SourceFiles
public extension SourceFilesList {
    static let sources: SourceFilesList = "Sources/**"
    static let tests: SourceFilesList = "Tests/**"
}

// MARK: - Resources
public extension ResourceFileElements {
    static let resources: ResourceFileElements = "Resources/**"
}
public extension ResourceFileElement {
    static let xibs: ResourceFileElement = "Sources/**/*.xib"
    static let storyboards: ResourceFileElement = "Resources/**/*.storyboard"
}
