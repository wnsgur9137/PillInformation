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
    static let alert: String = "알림"
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

// MARK: - SearchDetail
extension Constants.SearchDetail {
    static let copyComplete: String = "복사 완료!"
    
    static let medicineSeq: String = "품목 일련번호"
    static let medicineName: String = "품목명"
    static let entpSeq: String = "업체 일련번호"
    static let entpName: String = "업체명"
    static let chart: String = "성상"
    static let medicineImage: String = "약 이미지"
    static let printFront: String = "앞면"
    static let printBack: String = "뒷면"
    static let medicineShape: String = "모양"
    static let colorClass1: String = "색상(앞면)"
    static let colorClass2: String = "색상(뒷면)"
    static let lineFront: String = "분할선(앞면)"
    static let lineBack: String = "분할선(뒷면)"
    static let lengLong: String = "크기(장축)"
    static let lengShort: String = "크기(단축)"
    static let thick: String = "크기(두께)"
    static let imgRegistTs: String = "약학정보원 이미지 생성일"
    static let classNo: String = "분류번호"
    static let className: String = "분류명"
    static let etcOtcName: String = "전문/일반"
    static let medicinePermitDate: String = "품목허가일자"
    static let formCodeName: String = "제형코드이름"
    static let markCodeFrontAnal: String = "마크내용(앞면)"
    static let markCodeBackAnal: String = "마크내용(뒷면)"
    static let markCodeFrontImg: String = "마크이미지(앞면)"
    static let markCodeBackImg: String = "마크이미지(뒷면)"
    static let changeDate: String = "변경일자"
    static let markCodeFront: String = "마크코드(앞면)"
    static let markCodeBack: String = "마크코드(뒷면)"
    static let medicineEngName: String = "품목영문명"
    static let ediCode: String = "보험코드"
    
    static let efcyQestim: String = "효능"
    static let useMethodQesitm: String = "사용법"
    static let atpnWarnQesitm: String = "경고"
    static let atpnQesitm: String = "주의사항"
    static let intrcQesitm: String = "상호작용"
    static let seQesitm: String = "부작용"
    static let depositMethodQesitm: String = "보관법"
}

// MARK: - SearchShape
extension Constants.SearchShape {
    static let color: String = "색상"
    static let shape: String = "모양"
    static let line: String = "구분선"
    static let print: String = "문구"
    static let null: String = "없음"
    static let other: String = "기타"
    static let printPlaceholder: String = "알약에 그려진 문구를 입력해 보세요!"
}
