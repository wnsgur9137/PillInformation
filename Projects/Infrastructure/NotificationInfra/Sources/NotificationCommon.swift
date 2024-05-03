//
//  NotificationCommon.swift
//  NotificationInfra
//
//  Created by JunHyeok Lee on 5/3/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import UserNotifications

final class NotificationCommon: NSObject {
    
    /// Init UNUserNotificationCenter
    func initNotification() {
        UNUserNotificationCenter.current().delegate = self
    }
    
    
    /// Request UNUserNotification Authorization
    /// - Parameters:
    ///   - options: UNAuthorizationOptions
    ///   - completion: Escaping Closure
    func requestAuthorization(options: UNAuthorizationOptions,
                              completion: @escaping (Bool, (any Error)?) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: options, completionHandler: completion)
    }
    
    
}

extension NotificationCommon: UNUserNotificationCenterDelegate {
    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        return [.badge, .list, .banner, .sound]
    }
    
    /// 인앱 처리
    /// response.notification.request.content.userInfo
    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        
    }
}
