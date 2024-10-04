//
//  AlarmSettingModel.swift
//  MyPagePresentation
//
//  Created by JunHyeok Lee on 6/27/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation

public struct AlarmSettingModel {
    public let userID: Int
    public var isAgreeDaytimeNoti: Bool
    public var isAgreeNighttimeNoti: Bool
    
    public init(userID: Int, isAgreeDaytimeNoti: Bool, isAgreeNighttimeNoti: Bool) {
        self.userID = userID
        self.isAgreeDaytimeNoti = isAgreeDaytimeNoti
        self.isAgreeNighttimeNoti = isAgreeNighttimeNoti
    }
}
