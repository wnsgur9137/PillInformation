//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by JunHyeok Lee on 4/3/24.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project: Project = .project(
    name: "KakaoLibraries",
    product: .framework,
    dependencies: [
        .SPM.Kakao.KakaoSDKCommon,
        .SPM.Kakao.KakaoSDKAuth,
        .SPM.Kakao.KakaoSDKUser,
        .SPM.Kakao.KakaoSDKTalk
    ]
)
