//
//  DefaultAlarmSettingUseCase.swift
//  MyPageDomain
//
//  Created by JunHyeok Lee on 6/27/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RxSwift

import BaseDomain
import BasePresentation
import MyPagePresentation

public final class DefaultAlarmSettingUseCase: AlarmSettingUseCase {
    private let userRepository: UserMyPageRepository
    
    public init(with userRepository: UserMyPageRepository) {
        self.userRepository = userRepository
    }
}

extension DefaultAlarmSettingUseCase {
    public func fetchAlarmSetting() -> Single<AlarmSettingModel> {
        userRepository.fetchFirstUserStorage()
            .flatMap { user in
                self.userRepository.getUser(userID: user.id)
            }
            .flatMap { user in
                return Single.just(AlarmSettingModel(
                    userID: user.id,
                    isAgreeDaytimeNoti: user.isAgreeDaytimeNoti,
                    isAgreeNighttimeNoti: user.isAgreeNighttimeNoti
                ))
            }
            .catch { error in
                return Single.error(error)
            }
    }
    
    public func updateAlarmSetting(_ alarmSettingModel: AlarmSettingModel) -> Single<AlarmSettingModel> {
        userRepository.fetchFirstUserStorage()
            .flatMap { user in
                self.userRepository.getUser(userID: user.id)
            }
            .flatMap { user in
                let user = User(
                    id: user.id,
                    isAgreeAppPolicy: user.isAgreeAppPolicy,
                    isAgreeAgePolicy: user.isAgreeAgePolicy,
                    isAgreePrivacyPolicy: user.isAgreePrivacyPolicy,
                    isAgreeDaytimeNoti: alarmSettingModel.isAgreeDaytimeNoti,
                    isAgreeNighttimeNoti: alarmSettingModel.isAgreeNighttimeNoti,
                    accessToken: user.accessToken,
                    refreshToken: user.refreshToken,
                    social: user.social
                )
                return self.userRepository.postUser(user)
            }
            .flatMap { user in
                self.userRepository.updateStorage(user)
            }
            .flatMap { user in
                return Single.just(AlarmSettingModel(
                    userID: user.id,
                    isAgreeDaytimeNoti: user.isAgreeDaytimeNoti,
                    isAgreeNighttimeNoti: user.isAgreeNighttimeNoti
                ))
            }
            .catch { error in
                return Single.error(error)
            }
    }
}
