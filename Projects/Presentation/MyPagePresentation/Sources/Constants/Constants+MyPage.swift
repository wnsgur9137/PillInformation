//
//  Constants+MyPage.swift
//  MyPagePresentation
//
//  Created by JunHyeok Lee on 6/26/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation

import BasePresentation

extension Constants {
    struct MyPage { }
    struct AlarmSetting { }
    struct Policy { }
    struct OpenSourceLicense { }
}

extension Constants.MyPage {
    static let appAlarmSetting: String = "앱 알림 설정"
    static let appPolicy: String = "이용약관"
    static let privacyPolicy: String = "개인정보 처리방침"
    static let opensourceLicense: String = "오픈소스 라이센스"
    static let signout: String = "로그아웃"
    static let withdrawal: String = "회원 탈퇴"
}

extension Constants.AlarmSetting {
    static let title: String = "Alarm"
    static let loadErrorTitle: String = "불러오기에 실패했습니다."
    static let tryAgain: String = "다시 시도해주세요."
    static let changeErrorTitle: String = "변경에 실패했습니다."
    static let dayNotiTitle: String = "주간 알림 수신 동의"
    static let dayNotiDescription: String = "PillInformation이 제공하는 주간 알림을 받습니다."
    static let nightNotiTitle: String = "야간 알림 수신 동의"
    static let nightNotiDescription: String = "PillInformation이 제공하는 야간 알림을 받습니다."
}
