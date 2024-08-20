//
//  Constants+Image.swift
//  OnboardingPresentation
//
//  Created by JunHyeok Lee on 3/28/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit

import BasePresentation

extension Constants.Onboarding {
    struct Image { }
}

extension Constants.Onboarding.Image {
    static let appleLogo: UIImage = UIImage(named: "appleLogo") ?? UIImage()
    static let kakaoLogo: UIImage = UIImage(named: "kakaoLogo") ?? UIImage()
    static let googleLogo: UIImage = UIImage(named: "googleLogo") ?? UIImage()

    static let backward: UIImage = UIImage(systemName: "chevron.backward") ?? UIImage()
    static let forward: UIImage = UIImage(systemName: "chevron.forward") ?? UIImage()
    static let checkboxOn: UIImage = UIImage(named: "checkboxOn") ?? UIImage()
    static let checkboxOff: UIImage = UIImage(named: "checkboxOff") ?? UIImage()
}
