//
//  Dependency+SPM.swift
//  PillInformationManifests
//
//  Created by JunHyeok Lee on 3/20/24.
//

import Foundation
import ProjectDescription

// MARK: - Group
extension TargetDependency {
    public struct SPM {
        public struct Network { }
        public struct Layout { }
        public struct Reactive { }
        public struct UI { }
        public struct Test { }
    }
}
extension Package {
    public struct UI { }
    public struct Test { }
}

// MARK: - TargetDependency SPM
public extension TargetDependency.SPM.Network {
    static let Alamofire: TargetDependency = .external(name: "Alamofire")
    static let Moya: TargetDependency = .external(name: "RxMoya")
}
public extension TargetDependency.SPM.Layout {
    static let FlexLayout: TargetDependency = .external(name: "FlexLayout")
    static let PinLayout: TargetDependency = .external(name: "PinLayout")
}
public extension TargetDependency.SPM.Reactive {
    static let RxSwift: TargetDependency = .external(name: "RxSwift")
    static let RxCocoa: TargetDependency = .external(name: "RxCocoa")
    static let RxGesture: TargetDependency = .external(name: "RxGesture")
    static let ReactorKit: TargetDependency = .external(name: "ReactorKit")
}
public extension TargetDependency.SPM.UI {
//    static let SkeletonView: TargetDependency = .package(product: "SkeletonView")
//    static let KingFisher: TargetDependency = .package(product: "Kingfisher")
//    static let DropDown: TargetDependency = .package(product: "DropDown")
    static let SkeletonView: TargetDependency = .external(name: "SkeletonView")
    static let KingFisher: TargetDependency = .external(name: "Kingfisher")
    static let DropDown: TargetDependency = .external(name: "DropDown")
}
public extension TargetDependency.SPM.Test {
    static let RxBlocking: TargetDependency = .external(name: "RxBlocking")
    static let RxTest: TargetDependency = .external(name: "RxTest")
}

// MARK: - Package
public extension Package.UI {
//    static let SkeletonView: Package = .package(url: "https://github.com/Juanpe/SkeletonView", from: "1.0.0")
//    static let KingFihser: Package = .package(url: "https://github.com/onevcat/Kingfisher", from: "7.0.0")
//    static let DropDown: Package = .package(url: "https://github.com/AssistoLab/DropDown", .branch("master"))
}
