//
//  Constants+String.swift
//  OnboardingPresentation
//
//  Created by JunHyeok Lee on 3/28/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation

import BasePresentation

extension Constants.Onboarding {
    static let onboardingStart: String = "onboardingStart".localized
    static let appDescription: String = "\("appDescription".localized) \(Constants.appName)"

    static let appleLogin: String = "appleLogin".localized
    static let kakaoLogin: String = "kakaoLogin".localized
    static let canNotAppleSignInTitle: String = "canNotAppleSignInTitle".localized
    static let canNotKakaoSignInTitle: String = "canNotKakaoSignInTitle".localized
    static let canNotSignInTitle: String = "canNotSignInTitle".localized
    static let tryAgainLater: String = "tryAgain".localized
    static let start: String = "start".localized

    static let allAgreeAndConfirm: String = "allAgreeAndConfirm".localized
    static let backward: String = "backward".localized
    static let policyDescription: String = "\(Constants.appName) \("policyDescription".localized)"
    static let agePolicy: String = "onboardingAgePolicy".localized
    static let policy: String = "onboardingPolicy".localized
    static let privacyPolicy: String = "onboardingPrivacyPolicy".localized
    static let daytimeNotificationPolicy: String = "onboardingDaytimeNoti".localized
    static let nighttimeNotificationPolicy: String = "onboardingNighttimeNoti".localized

    static let appPolicy: String = "appPolicy".localized
    static let privacyPolicyTitle: String = "privacyPolicy".localized
    static let appPolicyContents: String = "appPolicyContents".localized
    static let privacyPolicyContents: String = "privacyPolicyContents".localized
    
    static let cautions: String = "cautions".localized
    static let cautionDescription: String = "cautionDescription".localized
}
