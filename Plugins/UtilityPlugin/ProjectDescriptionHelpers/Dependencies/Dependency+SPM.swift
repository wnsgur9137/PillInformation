//
//  Dependency+SPM.swift
//  ProjectDescriptionHelpers
//
//  Created by JUNHYEOK LEE on 1/22/24.
//

import Foundation
import ProjectDescription

// MARK: - Group
extension TargetDependency {
    public struct SwiftPM {
    }
}
extension Package {
    
}

// MARK: - Packages
public extension TargetDependency {
    static let alamofire: TargetDependency = .package(product: "Alamofire")
    static let moya: TargetDependency = .package(product: "Moya")
    
    static let rxSwift: TargetDependency = .package(product: "RxSwift")
    static let rxCocoa: TargetDependency = .package(product: "RxCocoa")
    static let rxGesture: TargetDependency = .package(product: "RxGesture")
    
    static let kingFisher: TargetDependency = .package(product: "Kingfisher")
    static let flexLayout: TargetDependency = .package(product: "FlexLayout")
    static let pinLayout: TargetDependency = .package(product: "PinLayout")
    
    static let rxBlocking: TargetDependency = .package(product: "RxBlocking")
    static let rxTest: TargetDependency = .package(product: "RxTest")
}

public extension Package {
    static let alamofire: Package = .package(url: "https://github.com/Alamofire/Alamofire", .upToNextMajor(from: "5.0.0"))
    static let moya: Package = .package(url: "https://github.com/Moya/Moya", .upToNextMajor(from: "15.0.0"))
    
    static let rxSwift: Package = .package(url: "https://github.com/ReactiveX/RxSwift", .upToNextMajor(from: "6.0.0"))
    static let rxGesture: Package = .package(url: "https://github.com/RxSwiftCommunity/RxGesture", .upToNextMajor(from: "4.0.0"))
    
    static let kingFihser: Package = .package(url: "https://github.com/onevcat/Kingfisher", .upToNextMajor(from: "7.0.0"))
    static let flexLayout: Package = .package(url: "https://github.com/layoutBox/FlexLayout", .branch("master"))
    static let pinLayout: Package = .package(url: "https://github.com/layoutBox/PinLayout", .branch("master"))
}
