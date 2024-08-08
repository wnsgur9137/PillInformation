//
//  HomeTabBarPage.swift
//  Home
//
//  Created by JunHyeok Lee on 8/8/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit

enum HomeTabBarPage {
    case recommend
    case notice
    
    init?(index: Int) {
        switch index {
        case 0: self = .recommend
        case 1: self = .notice
        default: return nil
        }
    }
    
    func title() -> String {
        switch self {
        case .recommend: "많이 찾는 알약"
        case .notice: "공지사항"
        }
    }
    
    func orderNumber() -> Int {
        switch self {
        case .recommend: return 0
        case .notice: return 1
        }
    }
    
    func isNew() -> Bool {
        switch self {
        case .recommend: return false
        case .notice: return true
        }
    }
}
