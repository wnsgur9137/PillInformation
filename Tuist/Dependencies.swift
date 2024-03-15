//
//  Dependencies.swift
//  Config
//
//  Created by JunHyeok Lee on 1/31/24.
//

import ProjectDescription
import ProjectDescriptionHelpers

let dependencies = Dependencies(
    carthage: [
        .github(path: "layoutBox/FlexLayout", requirement: .branch("master")),
        .github(path: "layoutBox/PinLayout", requirement: .branch("master"))
    ],
    swiftPackageManager: SwiftPackageManagerDependencies(
        [
            .remote(url: "https://github.com/ReactiveX/RxSwift.git", requirement: .upToNextMajor(from: "6.6.0")),
            .remote(url: "https://github.com/RxSwiftCommunity/RxGesture.git", requirement: .upToNextMajor(from: "4.0.0")),
            .remote(url: "https://github.com/ReactorKit/ReactorKit.git", requirement: .branch("master")),
            .remote(url: "https://github.com/RxSwiftCommunity/RxGesture", requirement: .upToNextMajor(from: "4.0.0")),
            .remote(url: "https://github.com/Alamofire/Alamofire", requirement: .upToNextMajor(from: "5.0.0")),
            .remote(url: "https://github.com/Moya/Moya", requirement: .upToNextMajor(from: "15.0.0")),
        ]
//        productTypes: [
//            "RxCocoaRuntime": .framework,
//        ]
    ),
    platforms: [.iOS]
)
