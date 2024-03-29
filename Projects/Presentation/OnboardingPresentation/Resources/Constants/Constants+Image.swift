//
//  Constants+Image.swift
//  OnboardingPresentation
//
//  Created by JunHyeok Lee on 3/28/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit

import BasePresentation

// MARK: - SignIn
extension Constants.SignIn.Image {
    static let appleLogo: UIImage = UIImage(named: "appleLogo") ?? UIImage()
    static let kakaoLogo: UIImage = UIImage(named: "kakaoLogo") ?? UIImage()
    static let googleLogo: UIImage = UIImage(named: "googleLogo") ?? UIImage()
}

// MARK: - OnboardingPolicy
extension Constants.OnboardingPolicy.Image {
    static let backward: UIImage = .init(systemName: "chevron.backward") ?? UIImage()
}
