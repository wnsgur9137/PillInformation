//
//  Constants+Bookmark.swift
//  BookmarkPresentation
//
//  Created by JunHyeok Lee on 7/23/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation

import BasePresentation

extension Constants {
    struct Bookmark {
        struct Image { }
    }
}

extension Constants.Bookmark {
    static let bookmark: String = "즐겨찾기"
    static let loadErrorMessage: String = "불러오기에 실패했습니다."
    static let saveErrorMessage: String = "저장에 실패했습니다."
    static let serverErrorMessage: String = "서버 오류가 발생했습니다."
}
