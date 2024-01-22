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

// MARK: - TargetDependency
public extension TargetDependency {
    static var presentations: [Self] {
        return [
            .project(layer: .presentation, view: .home),
            .project(layer: .presentation, view: .search),
            .project(layer: .presentation, view: .alarm),
            .project(layer: .presentation, view: .myPage),
        ]
    }
    static var domains: [Self] {
        return [
            .project(layer: .domain, view: .home),
            .project(layer: .domain, view: .search),
            .project(layer: .domain, view: .alarm),
            .project(layer: .domain, view: .myPage),
        ]
    }
    static var data: [Self] {
        return [
            .project(layer: .data, view: .home),
            .project(layer: .data, view: .search),
            .project(layer: .data, view: .alarm),
            .project(layer: .data, view: .myPage),
        ]
    }
    static var infrastructures: [Self] {
        return [
            .project(layer: .infrastructure, name: "Enum"),
            .project(layer: .infrastructure, name: "Network"),
            .project(layer: .infrastructure, name: "Protocol"),
            .project(layer: .infrastructure, name: "Extension"),
        ]
    }
    static var commons: [Self] {
        return [
            .project(layer: .common, name: "Builder"),
            .project(layer: .common, name: "ReuseableView"),
            .project(layer: .common, name: "Constants"),
        ]
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
