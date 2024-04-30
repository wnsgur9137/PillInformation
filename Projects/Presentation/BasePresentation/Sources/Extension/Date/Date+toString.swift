//
//  Date+toString.swift
//  BasePresentation
//
//  Created by JunHyeok Lee on 4/30/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation

extension Date {
    func toKSTString(format: String? = "YYYY. M. D. HH:mm:ss",
                     timeZone: TimeZone? = TimeZone(identifier: "Asia/Seoul")) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        return dateFormatter.string(from: self)
    }
}
