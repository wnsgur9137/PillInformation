//
//  NotificationRequest.swift
//  NotificationInfra
//
//  Created by JunHyeok Lee on 5/3/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import UserNotifications

final class NotificationRequest {
    
    
    /// Add Notification
    /// - Parameters:
    ///   - id: Identifier
    ///   - content: UNMutableNotificationContent
    func addNotification(id: String,
                         content: UNMutableNotificationContent) {
        let request = UNNotificationRequest(identifier: id,
                                            content: content,
                                            trigger: nil)
        UNUserNotificationCenter.current().add(request)
    }
    
    
    /// Add Notification With Completion
    /// - Parameters:
    ///   - id: Identifier
    ///   - content: UNMutableNotificationContent
    ///   - completion: Escaping Closure
    func addNotification(id: String,
                         content: UNMutableNotificationContent,
                         completion: @escaping(((any Error)?) -> Void)) {
        let request = UNNotificationRequest(identifier: id,
                                            content: content,
                                            trigger: nil)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: completion)
    }
    
    
    /// Add Trigger Notification
    /// - Parameters:
    ///   - id: Identifier
    ///   - content: UNMutableNotificationContent
    ///   - date: Date
    ///   - repeats: Repeats
    func addNotification(id: String,
                         content: UNMutableNotificationContent,
                         date: DateComponents,
                         repeats: Bool) {
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: repeats)
        let request = UNNotificationRequest(identifier: id,
                                            content: content,
                                            trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
    
    /// Add Trigger Notification
    /// - Parameters:
    ///   - id: Identifier
    ///   - content: UNMutableNotificationContent
    ///   - date: Date
    ///   - repeats: Repeats
    ///   - completion: Escaping Closure
    func addNotification(id: String,
                         content: UNMutableNotificationContent,
                         date: DateComponents,
                         repeats: Bool,
                         completion: @escaping(((any Error)?) -> Void)) {
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: repeats)
        let request = UNNotificationRequest(identifier: id,
                                            content: content,
                                            trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: completion)
    }
    
    /// Make Notification Content
    /// - Parameters:
    ///   - title: Title
    ///   - body: Body(Message)
    ///   - sound: Sound (Default: .default)
    ///   - badge: badge (Default: 1)
    func makeContent(title: String,
                             body: String,
                             sound: UNNotificationSound = .default,
                             badge: NSNumber = 1) -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = sound
        content.badge = badge
        return content
    }
}
