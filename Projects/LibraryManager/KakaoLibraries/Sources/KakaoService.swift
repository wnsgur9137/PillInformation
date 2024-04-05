//
//  KakaoService.swift
//  KakaoLibraries
//
//  Created by JunHyeok Lee on 4/5/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RxSwift

public class KakaoService { }

extension KakaoService {
    
    static let commonService: KakaoSDKCommonServicable = KakaoSDKCommonService()
    static let userService: KakaoSDKUserServicable = KakaoSDKUserService()
    static let authService: KakaoSDKAuthServicable = KakaoSDKAuthService()
    
    // MARK: - Common
    
    /// KakaoCommon
    public static func initSDK(appKey: String) {
        commonService.initSDK(appKey: appKey)
    }
    
    // MARK: - User
    
    /// KakaoUser
    public static func isKakaoTalkLoginAvailable() -> Bool {
        return userService.isKakaoTalkLoginAvailable()
    }
    
    /// KakaoUser
    public static func loginWithKakaoTalk(completion: @escaping (Result<String?, Error>) -> Void) {
        return userService.loginWithKakaoTalk(completion: completion)
    }
    
    /// RxKakaoUser
    public static func loginWithKakaoTalk() -> Single<String> {
        return userService.loginWithKakaoTalk()
    }
    
    /// KakaoUser
    public static func loginWithKakaoAccount(completion: @escaping (Result<String?, Error>) -> Void) {
        return userService.loginWithKakaoAccount(completion: completion)
    }
    
    /// RxKakaoUser
    public static func loginWithKakaoAccount() -> Single<String> {
        return userService.loginWithKakaoAccount()
    }
    
    // MARK: - Auth
    
    /// KakaoAuth
    public static func isKakaoTalkLoginUrl(_ url: URL) -> Bool {
        return authService.isKakaoTalkLoginUrl(url)
    }
    
    /// KakaoAuth
    public static func handleOpenURL(_ url: URL) -> Bool {
        return authService.handleOpenUrl(url)
    }
}
