//
//  AppDelegate.swift
//  PillInformation
//
//  Created by JunHyeok Lee on 3/19/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

import KakaoLibraries
import NotificationInfra

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication,  didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) -> Bool {
        
        /// Notification
        NotificationService.initService()
        NotificationService.requestAuthorization() { auth, error in
            if let error = error {
                print("Error: \(error)")
            }
        }
        
        /// Init KakaoSDK
        if let appConfigurations = Bundle.main.infoDictionary?["AppConfigurations"] as? [String: String],
           let kakaoNativeAppKey = appConfigurations["KAKAO_NATIVE_APP_KEY"] {
            KakaoService.initSDK(appKey: kakaoNativeAppKey)
        }
        
        /// IQKeyboardManager
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.resignOnTouchOutside = true
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
}
