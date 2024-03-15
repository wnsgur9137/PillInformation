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
        public struct Network { }
        public struct Reactive { }
        public struct UI { }
        public struct Test { }
    }
}
extension Package {
    public struct UI { }
    public struct Test { }
}

// MARK: - TargetDependency SwiftPM
public extension TargetDependency.SwiftPM.Network {
    static let Alamofire: TargetDependency = .external(name: "Alamofire")
    static let Moya: TargetDependency = .external(name: "RxMoya")
}
public extension TargetDependency.SwiftPM.Reactive {
    static let RxSwift: TargetDependency = .external(name: "RxSwift")
    static let RxCocoa: TargetDependency = .external(name: "RxCocoa")
    static let RxGesture: TargetDependency = .external(name: "RxGesture")
    static let ReactorKit: TargetDependency = .external(name: "ReactorKit")
}
public extension TargetDependency.SwiftPM.UI {
    static let SkeletonView: TargetDependency = .package(product: "SkeletonView")
    static let KingFisher: TargetDependency = .package(product: "Kingfisher")
    static let DropDown: TargetDependency = .package(product: "DropDown")
}
public extension TargetDependency.SwiftPM.Test {
    static let RxBlocking: TargetDependency = .external(name: "RxBlocking")
    static let RxTest: TargetDependency = .external(name: "RxTest")
}

// MARK: - Package
public extension Package.UI {
    static let SkeletonView: Package = .package(url: "https://github.com/Juanpe/SkeletonView", .upToNextMajor(from: "1.0.0"))
    static let KingFihser: Package = .package(url: "https://github.com/onevcat/Kingfisher", .upToNextMajor(from: "7.0.0"))
    static let DropDown: Package = .package(url: "https://github.com/AssistoLab/DropDown", .branch("master"))
}
