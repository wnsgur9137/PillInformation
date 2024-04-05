//
//  KakaoAuth.swift
//  KakaoLibraries
//
//  Created by JunHyeok Lee on 4/5/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import KakaoSDKAuth
import RxKakaoSDKAuth

protocol KakaoSDKAuthServicable {
    func isKakaoTalkLoginUrl(_ url: URL) -> Bool
    func handleOpenUrl(_ url: URL) -> Bool
}

final class KakaoSDKAuthService: KakaoSDKAuthServicable {
    func isKakaoTalkLoginUrl(_ url: URL) -> Bool {
        return AuthApi.isKakaoTalkLoginUrl(url)
    }
    
    func handleOpenUrl(_ url: URL) -> Bool {
        return AuthController.handleOpenUrl(url: url)
    }
}
