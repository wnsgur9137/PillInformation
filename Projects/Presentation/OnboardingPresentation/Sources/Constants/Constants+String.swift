//
//  Constants+String.swift
//  OnboardingPresentation
//
//  Created by JunHyeok Lee on 3/28/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation

import BasePresentation

extension Constants.SignIn {
    static let appleLogin = "Apple 로그인"
    static let kakaoLogin = "Kakao 로그인"
    static let googleLogin = "Google 로그인"
}

extension Constants.OnboardingPolicy {
    static let confirm = "시작"
    static let allAgreeAndConfirm = "모두 동의하고 시작"
    static let backward = "뒤로"
    static let policyTitle = "이용약관"
    static let policyDescription = "\(Constants.appName) 서비스 이용을 위해\n약관에 동의해주세요."
    static let agePolicy = "(필수) 만 14세 이상입니다."
    static let policy = "(필수) 이용약관 동의"
    static let privacyPolicy = "(필수) 개인정보 처리 방침"
    static let daytimeNotificationPolicy = "(선택) 주간 알림 수신 동의"
    static let nighttimeNotificationPolicy = "(선택) 야간 알림 수신 동의"
}
