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
            public struct `Enum` { }
            public struct Network { }
            public struct `Protocol` { }
            public struct `Extension` { }
        }
        public struct Common {
            public struct Builder { }
            public struct ReuseableView { }
            public struct Constants { }
        }
    }
}
extension TargetDependency.Project.Presentations {
    static let Presentations: TargetDependency = .project(layer: .presentation)
}
extension TargetDependency.Project.Domain {
    static let Domains: TargetDependency = .project(layer: .domain)
}
extension TargetDependency.Project.Data {
    static let Data: TargetDependency = .project(layer: .data)
}
extension TargetDependency.Project.Infrastructure {
    static let Infrastructure: TargetDependency = .project(layer: .infrastructure)
}
extension TargetDependency.Project.Common {
    static let Common: TargetDependency = .project(layer: .common)
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
