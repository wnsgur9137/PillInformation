//
//  NotificationService.swift
//  ProjectDescriptionHelpers
//
//  Created by JunHyeok Lee on 5/3/24.
//

import UIKit
import RxSwift

/// UNNotificationCenter를 사용하기 위한 Service
public class NotificationService: NSObject {
    private static let common: NotificationCommon = NotificationCommon()
    private static let request: NotificationRequest = NotificationRequest()
}

// MARK: - Common
extension NotificationService {
    
    /// Init UNNotificationCenter
    public static func initService() {
        common.initNotification()
    }
    
    /// Requset UNNotification Authorization
    /// - Parameters:
    ///   - options: UNAuthorizationOptions (Default: [.alert, .badge, .sound])
    ///   - completion: Esaping Closure
    public static func requestAuthorization(options: UNAuthorizationOptions = [.alert, .badge, .sound],
                                            completion: @escaping (Bool, Error?) -> Void) {
        common.requestAuthorization(options: options, completion: completion)
    }
}

// MARK: - Add Notification
extension NotificationService {
    
    /// Add Notification
    /// - Parameters:
    ///   - id: Identifier
    ///   - title: Title
    ///   - body: Body(Message)
    ///   - badge: Badge(Default: 1)
    public static func addNotification(id: String,
                                       title: String,
                                       body: String,
                                       badge: NSNumber = 1) {
        let content = request.makeContent(title: title, body: body, badge: badge)
        request.addNotification(id: id, content: content)
    }
    
    /// Add Notification with Escaping Clouser
    /// - Parameters:
    ///   - id: Identifier
    ///   - title: Title
    ///   - body: Body(Message)
    ///   - badge: Badge(Default: 1)
    ///   - completion: Escaping Closure
    public static func addNotification(id: String,
                                       title: String,
                                       body: String,
                                       badge: NSNumber = 1,
                                       completion: @escaping(((any Error)?) -> Void)) {
        let content = request.makeContent(title: title, body: body, badge: badge)
        request.addNotification(id: id, content: content, completion: completion)
    }
    
    /// Add Trigger Notification
    /// - Parameters:
    ///   - id: Identifier
    ///   - title: Title
    ///   - body: Body(Message)
    ///   - badge: Badge(Default: 1)
    ///   - date: Date
    ///   - repeats: Repeats
    public static func addTriggerNotification(id: String,
                                              title: String,
                                              body: String,
                                              badge: NSNumber = 1,
                                              date: DateComponents,
                                              repeats: Bool) {
        let content = request.makeContent(title: title, body: body, badge: badge)
        request.addNotification(id: id, content: content, date: date, repeats: repeats)
    }
    
    /// Add Trigger Notification with Escaping Closure
    /// - Parameters:
    ///   - id: Identifier
    ///   - title: Title
    ///   - body: Body(Message)
    ///   - badge: Badge(Default: 1)
    ///   - date: Date
    ///   - repeats: Repeats
    ///   - completion: Escaping Closure
    public static func addTriggerNotification(id: String,
                                              title: String,
                                              body: String,
                                              badge: NSNumber = 1,
                                              date: DateComponents,
                                              repeats: Bool,
                                              completion: @escaping(((any Error)?) -> Void)) {
        let content = request.makeContent(title: title, body: body, badge: badge)
        request.addNotification(id: id, content: content, date: date, repeats: repeats, completion: completion)
    }
    
    /// Delete pending notification
    /// - Parameter id: Identifier
    public static func deletePendingNotification(id: String) {
        request.deletePendingNotifications(ids: [id])
    }
    
    /// Delete pending notifications
    /// - Parameter ids: Identifiers
    public static func deletePendingNotifications(ids: [String]) {
        request.deletePendingNotifications(ids: ids)
    }
    
    /// Delete all pending notifications
    public static func deleteAllPendingNotifications() {
        request.deleteAllPendingNotifications()
    }
    
    /// Delete delivered notification
    /// - Parameter id: Idetifier
    public static func deleteDeliveredNotification(id: String) {
        request.deleteDeliveredNotifications(ids: [id])
    }
    
    /// Delete delivered notifications
    /// - Parameter ids: Identifiers
    public static func deleteDeliveredNotifications(ids: [String]) {
        request.deleteDeliveredNotifications(ids: ids)
    }
    
    /// Delete all delivered notifications
    public static func deleteAllDeliveredNotifications() {
        request.deleteAllDeliveredNotifications()
    }
}
