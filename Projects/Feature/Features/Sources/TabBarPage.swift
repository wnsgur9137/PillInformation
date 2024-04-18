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
    case myPage
    
    init?(index: Int) {
        switch index {
        case 0: self = .home
        case 1: self = .bookmark
        case 2: self = .search
        case 3: self = .alarm
        case 4: self = .myPage
        default: return nil
        }
    }
    
    func title() -> String {
        switch self {
        case .home: return "홈"
        case .bookmark: return "즐겨찾기"
        case .search: return "검색"
        case .alarm: return "알람"
        case .myPage: return "내정보"
        }
    }
    
    func orderNumber() -> Int {
        switch self {
        case .home: return 0
        case .bookmark: return 1
        case .search: return 2
        case .alarm: return 3
        case .myPage: return 4
        }
    }
    
    func image() -> UIImage? {
        switch self {
        case .home: return UIImage(systemName: "house")
        case .bookmark: return UIImage(systemName: "star")
        case .search: return UIImage(systemName: "magnifyingglass")
        case .alarm: return UIImage(systemName: "deskclock")
        case .myPage: return UIImage(systemName: "person")
        }
    }
    
    func selectedImage() -> UIImage? {
        switch self {
        case .home: return UIImage()
        case .bookmark: return UIImage(systemName: "star.fill")
        case .search: return UIImage()
        case .alarm: return UIImage()
        case .myPage: return UIImage()
        }
    }
}
