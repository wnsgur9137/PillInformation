//
//  KakaoCommon.swift
//  KakaoLibraries
//
//  Created by JunHyeok Lee on 4/5/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import KakaoSDKCommon

protocol KakaoSDKCommonServicable {
    func initSDK(appKey: String)
}

final class KakaoSDKCommonService: KakaoSDKCommonServicable {
    func initSDK(appKey: String) {
        KakaoSDK.initSDK(appKey: appKey)
    }
}

