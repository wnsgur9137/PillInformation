//
//  TabBarPage.swift
//  Base
//
//  Created by JunHyeok Lee on 1/29/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit

enum TabBarPage {
    case home
    case search
    case alarm
    case myPage
    
    init?(index: Int) {
        switch index {
        case 0: self = .home
        case 1: self = .search
        case 2: self = .alarm
        case 3: self = .myPage
        default: return nil
        }
    }
    
    func title() -> String {
        switch self {
        case .home: return "홈"
        case .search: return "검색"
        case .alarm: return "알람"
        case .myPage: return "내정보"
        }
    }
    
    func orderNumber() -> Int {
        switch self {
        case .home: return 0
        case .search: return 1
        case .alarm: return 2
        case .myPage: return 3
        }
    }
    
    func image() -> UIImage {
        switch self {
        case .home: return UIImage()
        case .search: return UIImage()
        case .alarm: return UIImage()
        case .myPage: return UIImage()
        }
    }
    
    func selectedImage() -> UIImage {
        switch self {
        case .home: return UIImage()
        case .search: return UIImage()
        case .alarm: return UIImage()
        case .myPage: return UIImage()
        }
    }
}
