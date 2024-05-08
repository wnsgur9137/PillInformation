//
//  NotificationIdentifier.swift
//  NotificationInfra
//
//  Created by JunHyeok Lee on 5/3/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation

public struct NotificationIdentifier {
//    public static func alarm(id: Int) -> String { return "Alarm-\(id)" }
    public static func alarm(id: Int, day: Int) -> String { return "Alarm-\(id)-\(day)" }
    public static func timer(id: Int) -> String { return "Timer-\(id)" }
}
