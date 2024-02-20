//
//  Dependency.swift
//  ProjectDescriptionHelpers
//
//  Created by JUNHYEOK LEE on 1/22/24.
//

import Foundation
import ProjectDescription

public enum ProjectLayer: String {
    case application = "Application"
    case presentation = "Presentation"
    case domain = "Domain"
    case data = "Data"
    case infrastructure = "Infrastructure"
    case common = "Common"
    case libraryManager = "LibraryManager"
}

public enum ProjectView: String {
    case home = "Home"
    case search = "Search"
    case alarm = "Alarm"
    case myPage = "MyPage"
}

// MARK: - Projects
extension TargetDependency {
    public struct Project {
        public struct Presentations { }
        public struct Domain { }
        public struct Data { }
        public struct Infrastructure { }
        public struct Common {
            public struct `Enum` { }
            public struct `Protocol` { }
            public struct `Extension` { }
            public struct Constants { }
        }
        public struct LibraryManager { }
    }
}

// MARK: - Presentation
public extension TargetDependency.Project.Presentations {
    static let BaseTab: TargetDependency = .project(layer: .presentation, name: "BaseTab")
    static let Home: TargetDependency = .project(layer: .presentation, name: "Home")
    static let Search: TargetDependency = .project(layer: .presentation, name: "Search")
    static let Alarm: TargetDependency = .project(layer: .presentation, name: "Alarm")
    static let MyPage: TargetDependency = .project(layer: .presentation, name: "MyPage")
    static let All: TargetDependency = .project(layer: .presentation, name: "Presentations")
}

// MARK: - Domain
public extension TargetDependency.Project.Domain {
    static let Domains: TargetDependency = .project(layer: .domain, name: "Domains")
    static let HomeDomain: TargetDependency = .project(layer: .domain, name: "HomeDomain")
    static let SearchDomain: TargetDependency = .project(layer: .domain, name: "SearchDomain")
    static let AlarmDomain: TargetDependency = .project(layer: .domain, name: "AlarmDomain")
    static let MyPageDomain: TargetDependency = .project(layer: .domain, name: "MyPageDomain")
}

// MARK: - Data
public extension TargetDependency.Project.Data {
    static let Data: TargetDependency = .project(layer: .data, name: "Data")
    static let HomeData: TargetDependency = .project(layer: .data, name: "HomeData")
    static let SearchData: TargetDependency = .project(layer: .data, name: "SearchData")
    static let AlarmData: TargetDependency = .project(layer: .data, name: "AlarmData")
    static let MyPageData: TargetDependency = .project(layer: .data, name: "MyPageData")
}

// MARK: - Infrastructure
public extension TargetDependency.Project.Infrastructure {
    static let Infrastructures: TargetDependency = .project(layer: .infrastructure, name: "Infrastructures")
    static let Builder: TargetDependency = .project(layer: .infrastructure, name: "Builder")
    static let NetworkInfra: TargetDependency = .project(layer: .infrastructure, name: "NetworkInfra")
    static let ReuseableView: TargetDependency = .project(layer: .infrastructure, name: "ReuseableView")
}

// MARK: - Common
public extension TargetDependency.Project.Common {
    static let Common: TargetDependency = .common()
}

// MARK: - LibraryManager
public extension TargetDependency.Project.LibraryManager {
    static let NetworkLibraries: TargetDependency = .project(layer: .libraryManager, name: "NetworkLibraries")
    static let ReactiveLibraries: TargetDependency = .project(layer: .libraryManager, name: "ReactiveLibraries")
    static let LayoutLibraries: TargetDependency = .project(layer: .libraryManager, name: "LayoutLibraries")
    static let UILibraries: TargetDependency = .project(layer: .libraryManager, name: "UILibraries")
    static let PresentationLibrarys: [TargetDependency] = [ReactiveLibraries, LayoutLibraries, UILibraries]
}

// MARK: - TargetDependency
public extension TargetDependency {
    static func project(layer: ProjectLayer) -> Self {
        return .project(target: layer.rawValue, path: .relative(to: layer))
    }
    static func project(layer: ProjectLayer, view: ProjectView) -> Self {
        return .project(target: view.rawValue, path: .relative(to: layer, view: view))
    }
    static func project(layer: ProjectLayer, name: String) -> Self {
        return .project(target: name, path: .relative(to: layer, name: name))
    }
    static func common() -> Self {
        let common = ProjectLayer.common.rawValue
        return .project(target: common, path: .relativeToProject(name: common))
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
