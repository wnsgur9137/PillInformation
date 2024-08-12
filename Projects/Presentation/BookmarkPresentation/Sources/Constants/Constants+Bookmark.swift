//
//  Constants+Bookmark.swift
//  BookmarkPresentation
//
//  Created by JunHyeok Lee on 7/23/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import UIKit

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
    static let emptyBookmark: String = "즐겨찾기한 알약이 없어요"
    static let emptyBookmarkDescription: String = "알약을 검색하고 즐겨찾기를 추가해보세요"
    static let deleteAll: String = "모두 삭제하기"
    static let askDeleteAll: String = "모두 삭제하시겠습니까?"
}

extension Constants.Bookmark.Image {
    static let xmarkCircle: UIImage = UIImage(systemName: "xmark.circle") ?? UIImage()
}
