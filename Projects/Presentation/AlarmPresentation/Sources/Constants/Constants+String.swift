//
//  Constants+String.swift
//  AlarmPresentation
//
//  Created by JunHyeok Lee on 4/18/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation

import BasePresentation

extension Constants.AlarmTabBarController {
    static let alarm = "알람"
    static let timer = "타이머"
}

extension Constants.AlarmViewController {
    static let alarm = "알람"
    static let emptyAlarm = "타이머가 설정되지 않았어요"
    static let addTimer = "타이머 설정하기"
    static let sunday = "일"
    static let monday = "월"
    static let tuesday = "화"
    static let wednesday = "수"
    static let thursday = "목"
    static let friday = "금"
    static let saturday = "토"
    static let title = "알람 이름"
    static let save = "저장"
    static let saveErrorTitle = "알람 등록에 실패했습니다."
    static let tryAgain = "다시 시도해주세요."
    static let notificationTitle = "알람시간이에요!"
}

extension Constants.TimerViewController {
    static let timer = "타이머"
    static let recentTimer = "이전 타이머 기록"
    static let notificationTitle = "타이머가 종료되었어요!"
}

extension Constants.TimerDetailViewController {
    static let timer = "타이머"
    static let title = "타이머 이름"
}
