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
        public struct Presentations {
            public struct Home { }
            public struct Search { }
            public struct Alarm { }
            public struct MyPage { }
        }
        public struct Domain {
            public struct Home { }
            public struct Search { }
            public struct Alarm { }
            public struct MyPage { }
        }
        public struct Data {
            public struct Home { }
            public struct Search { }
            public struct Alarm { }
            public struct MyPage { }
        }
        public struct Infrastructure {
            public struct Network { }
            public struct Builder { }
            public struct Adapter { }
            public struct ReuseableView { }
        }
        public struct Common {
            public struct `Enum` { }
            public struct `Protocol` { }
            public struct `Extension` { }
            public struct Constants { }
        }
    }
}

// MARK: - Presentation
public extension TargetDependency.Project.Presentations {
    static let BaseTab: TargetDependency = .project(layer: .presentation, name: "BaseTab")
    static let Presentations: TargetDependency = .project(layer: .presentation, name: "Presentations")
}
public extension TargetDependency.Project.Presentations.Home {
    static let Home: TargetDependency = .project(layer: .presentation, name: "Home")
    static let Package: [TargetDependency] = [Home]
}
public extension TargetDependency.Project.Presentations.Search {
    static let Search: TargetDependency = .project(layer: .presentation, name: "Search")
    static let Package: [TargetDependency] = [Search]
}
public extension TargetDependency.Project.Presentations.Alarm {
    static let Alarm: TargetDependency = .project(layer: .presentation, name: "Alarm")
    static let Package: [TargetDependency] = [Alarm]
}
public extension TargetDependency.Project.Presentations.MyPage {
    static let MyPage: TargetDependency = .project(layer: .presentation, name: "MyPage")
    static let Package: [TargetDependency] = [MyPage]
}

// MARK: - Domain
public extension TargetDependency.Project.Domain {
    static let Domains: TargetDependency = .project(layer: .domain)
}

// MARK: - Data
public extension TargetDependency.Project.Data {
    static let Data: TargetDependency = .project(layer: .data)
}

// MARK: - Infrastructure
public extension TargetDependency.Project.Infrastructure {
    static let Infrastructures: TargetDependency = .project(layer: .infrastructure, name: "Infrastructures")
}
public extension TargetDependency.Project.Infrastructure.Builder {
    static let Builder: TargetDependency = .project(layer: .infrastructure, name: "Builder")
    static let Package: [TargetDependency] = [Builder]
}
public extension TargetDependency.Project.Infrastructure.Adapter {
    static let Adapter: TargetDependency = .project(layer: .infrastructure, name: "Adapter")
    static let Package: [TargetDependency] = [Adapter]
}
public extension TargetDependency.Project.Infrastructure.Network {
    static let Network: TargetDependency = .project(layer: .infrastructure, name: "Network")
    static let Package: [TargetDependency] = [Network]
}
public extension TargetDependency.Project.Infrastructure.ReuseableView {
    static let ReuseableView: TargetDependency = .project(layer: .infrastructure, name: "ReuseableView")
    static let Package: [TargetDependency] = [ReuseableView]
}

// MARK: - Common
public extension TargetDependency.Project.Common {
    static let Common: TargetDependency = .common()
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
