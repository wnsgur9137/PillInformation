//
//  Constants+String.swift
//  SearchPresentation
//
//  Created by JunHyeok Lee on 5/8/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation

import BasePresentation

// MARK: - Search
extension Constants.Search {
    static let search: String = "검색"
    static let tooShortKeywordError: String = "알약명을 두 글자 이상 입력해주세요."
    static let serverError: String = "서버 오류가 발생했습니다.\n다시 시도해 주세요."
    static let noHaveRecentKeyword: String = "삭제할 검색 기록이 없습니다."
    static let recommendKeyword: String = "추천 검색어"
    static let recentKeyword: String = "최근 검색 기록"
}

// MARK: - SearchResult
extension Constants.SearchResult {
    static let isEmpty: String = "검색 결과가 없어요"
}

// MARK: - SearchShape
extension Constants.SearchShape {
    static let title: String = "모양으로 검색하기"
    static let color: String = "색상"
    static let shape: String = "모양"
    static let line: String = "구분선"
    static let print: String = "문구"
    static let null: String = "없음"
    static let other: String = "기타"
    static let selectedShape: String = "선택한 옵션"
    static let printPlaceholder: String = "알약에 그려진 문구를 입력해 보세요!"
    static let emptyErrorTitle: String = "한 개 이상을 선택해 주세요"
}
