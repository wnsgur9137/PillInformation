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
    case bookmark
    case search
    case alarm
    
    init?(index: Int) {
        switch index {
        case 0: self = .home
        case 1: self = .search
        case 2: self = .bookmark
        case 3: self = .alarm
        default: return nil
        }
    }
    
    func title() -> String {
        switch self {
        case .home: return "홈"
        case .search: return "검색"
        case .bookmark: return "즐겨찾기"
        case .alarm: return "알람"
        }
    }
    
    func orderNumber() -> Int {
        switch self {
        case .home: return 0
        case .search: return 1
        case .bookmark: return 2
        case .alarm: return 3
        }
    }
    
    func image() -> UIImage? {
        switch self {
        case .home: return UIImage(systemName: "house")
        case .search: return UIImage(systemName: "magnifyingglass")
        case .bookmark: return UIImage(systemName: "star")
        case .alarm: return UIImage(systemName: "deskclock")
        }
    }
    
    func selectedImage() -> UIImage? {
        switch self {
        case .home: return UIImage()
        case .search: return UIImage()
        case .bookmark: return UIImage(systemName: "star.fill")
        case .alarm: return UIImage()
        }
    }
}
