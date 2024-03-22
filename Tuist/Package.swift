// swift-tools-version: 5.9

import PackageDescription

#if TUIST
import ProjectDescription
import ProjectDescriptionHelpers

let packageSettings = PackageSettings(
    productTypes: [:],
    baseSettings: Settings.settings(
        configurations: [
            .debug(name: .DEV),
            .release(name: .PROD),
            .debug(name: .TEST_DEV),
            .debug(name: .TEST_PROD)
        ]
    )
)
#endif

let package = Package(
    name: "PackageName",
    dependencies: [
        .package(url: "https://github.com/layoutBox/FlexLayout", branch: "master"),
        .package(url: "https://github.com/layoutBox/PinLayout", branch: "master"),
        .package(url: "https://github.com/Alamofire/Alamofire", from: "5.0.0"),
        .package(url: "https://github.com/ReactiveX/RxSwift.git", from: "6.6.0"),
        .package(url: "https://github.com/RxSwiftCommunity/RxGesture.git", from: "4.0.0"),
        .package(url: "https://github.com/ReactorKit/ReactorKit.git", branch: "master"),
        .package(url: "https://github.com/RxSwiftCommunity/RxGesture", from: "4.0.0"),
        .package(url: "https://github.com/Alamofire/Alamofire", from: "5.0.0"),
        .package(url: "https://github.com/Moya/Moya", from: "15.0.0"),
        .package(url: "https://github.com/Juanpe/SkeletonView", from: "1.0.0"),
        .package(url: "https://github.com/onevcat/Kingfisher", from: "7.11.0"),
        .package(url: "https://github.com/AssistoLab/DropDown", branch: "master")
    ]
)
