//
//  HomeTabBarPage.swift
//  Home
//
//  Created by JunHyeok Lee on 8/8/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit

enum HomeTabBarPage: Int {
    case recommend
    case map
    case notice
    
    init?(index: Int) {
        switch index {
        case 0: self = .recommend
        case 1: self = .map
        case 2: self = .notice
        default: return nil
        }
    }
    
    func title() -> String {
        switch self {
        case .recommend: "많이 찾는 알약"
        case .map: "주변 약국"
        case .notice: "공지사항"
        }
    }
    
    func orderNumber() -> Int {
        return self.rawValue
    }
    
    func isNew() -> Bool {
        switch self {
        case .recommend: return false
        case .map: return true
        case .notice: return true
        }
    }
}
