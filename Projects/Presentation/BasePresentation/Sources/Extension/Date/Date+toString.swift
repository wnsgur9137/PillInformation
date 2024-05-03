//
//  Date+toString.swift
//  BasePresentation
//
//  Created by JunHyeok Lee on 4/30/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation

extension Date {
    public func toKSTString(format: String = "YYYY. M. D. HH:mm:ss",
                            hasAMPM: Bool = false,
                            timeZone: TimeZone? = TimeZone(identifier: "Asia/Seoul")) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        if hasAMPM {
            dateFormatter.dateFormat = "a " + format
            dateFormatter.amSymbol = "AM"
            dateFormatter.amSymbol = "PM"
        }
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        return dateFormatter.string(from: self)
    }
}
