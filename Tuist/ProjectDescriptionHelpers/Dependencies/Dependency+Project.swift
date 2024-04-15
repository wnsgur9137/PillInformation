//
//  Dependency+Project.swift
//  PillInformationManifests
//
//  Created by JunHyeok Lee on 3/20/24.
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
    static let Common: TargetDependency = .project(target: "Common", path: .relativeToProject(name: "Common"))
}

// MARK: - InjectionManager
public extension TargetDependency.Project.InjectionManager {
    static let Infrastructure: TargetDependency = .project(layer: .InjectionManager, name: "InfraInjectionManager")
}

// MARK: - Feature
public extension TargetDependency.Project.Feature {
    static let Features: TargetDependency = .project(layer: .Feature, name: "Features")
    static let Splash: TargetDependency = .project(layer: .Feature, name: "Splash")
    static let Onboarding: TargetDependency = .project(layer: .Feature, name: "Onboarding")
    static let Home: TargetDependency = .project(layer: .Feature, name: "Home")
    static let Search: TargetDependency = .project(layer: .Feature, name: "Search")
    static let Alarm: TargetDependency = .project(layer: .Feature, name: "Alarm")
    static let MyPage: TargetDependency = .project(layer: .Feature, name: "MyPage")
}

// MARK: - Presentation
public extension TargetDependency.Project.Feature.Presentation {
    static let Base: TargetDependency = .project(layer: .Presentation, name: "BasePresentation")
    static let Splash: TargetDependency = .project(layer: .Presentation, name: "SplashPresentation")
    static let Onboarding: TargetDependency = .project(layer: .Presentation, name: "OnboardingPresentation")
    static let Home: TargetDependency = .project(layer: .Presentation, name: "HomePresentation")
    static let Search: TargetDependency = .project(layer: .Presentation, name: "SearchPresentation")
    static let Alarm: TargetDependency = .project(layer: .Presentation, name: "AlarmPresentation")
    static let MyPage: TargetDependency = .project(layer: .Presentation, name: "MyPagePresentation")
}

// MARK: - Domain
public extension TargetDependency.Project.Feature.Domain {
    static let Base: TargetDependency = .project(layer: .Domain, name: "BaseDomain")
    static let Splash: TargetDependency = .project(layer: .Domain, name: "SplashDomain")
    static let Onboarding: TargetDependency = .project(layer: .Domain, name: "OnboardingDomain")
    static let Home: TargetDependency = .project(layer: .Domain, name: "HomeDomain")
    static let Search: TargetDependency = .project(layer: .Domain, name: "SearchDomain")
    static let Alarm: TargetDependency = .project(layer: .Domain, name: "AlarmDomain")
    static let MyPage: TargetDependency = .project(layer: .Domain, name: "MyPageDomain")
}

// MARK: - Data
public extension TargetDependency.Project.Feature.Data {
    static let Base: TargetDependency = .project(layer: .Data, name: "BaseData")
    static let Splash: TargetDependency = .project(layer: .Data, name: "SplashData")
    static let Onboarding: TargetDependency = .project(layer: .Data, name: "OnboardingData")
    static let Home: TargetDependency = .project(layer: .Data, name: "HomeData")
    static let Search: TargetDependency = .project(layer: .Data, name: "SearchData")
    static let Alarm: TargetDependency = .project(layer: .Data, name: "AlarmData")
    static let MyPage: TargetDependency = .project(layer: .Data, name: "MyPageData")
}

// MARK: - Infrastructure
public extension TargetDependency.Project.Infrastructure {
    static let Network: TargetDependency = .project(layer: .Infrastructure, name: "NetworkInfra")
}

// MARK: - LibraryManager
public extension TargetDependency.Project.LibraryManager {
    static let NetworkLibraries: TargetDependency = .project(layer: .LibraryManager, name: "NetworkLibraries")
    static let DataLibraries: TargetDependency = .project(layer: .LibraryManager, name: "DataLibraries")
    static let KakaoLibraries: TargetDependency = .project(layer: .LibraryManager, name: "KakaoLibraries")
    static let ReactiveLibraries: TargetDependency = .project(layer: .LibraryManager, name: "ReactiveLibraries")
    static let LayoutLibraries: TargetDependency = .project(layer: .LibraryManager, name: "LayoutLibraries")
    static let UILibraries: TargetDependency = .project(layer: .LibraryManager, name: "UILibraries")
}

// MARK: - TargetDepenendency
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
