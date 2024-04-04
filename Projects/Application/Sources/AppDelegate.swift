//
//  AppDelegate.swift
//  PillInformation
//
//  Created by JunHyeok Lee on 3/19/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit
import KakaoSDKCommon
import RxKakaoSDKCommon

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) -> Bool {
        if let appConfigurations = Bundle.main.infoDictionary?["AppConfigurations"] as? [String: String],
           let kakaoNativeAppKey = appConfigurations["KAKAO_NATIVE_APP_KEY"] {
            KakaoSDK.initSDK(appKey: kakaoNativeAppKey)
        }
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
}
