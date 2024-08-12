//
//  Constants+String.swift
//  BasePresentation
//
//  Created by JunHyeok Lee on 3/21/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation

extension Constants {
    public static let appName: String = "PillInformation"
    
    public static let warningMessage: String = "PillInformation 앱의 알약 검색 앱을 사용하여 약물을 섭취하는 경우 발생할 수 있는 문제에 대해 책임을 지지 않습니다. 이 앱은 오직 일반적인 참고 목적으로만 정보를 제공하며, 의료 전문가의 조언을 대체하지 않습니다.\n\n앱을 통해 제공되는 정보에 의존하여 약물을 선택하거나 섭취하는 행위에 대해 발생하는 모든 문제에 대한 책임은 사용자 본인에게 있습니다. 어떠한 상황에서도 약물을 복용하거나 전문 의료 도움이 필요한 경우 반드시 자격 있는 의료 전문가와 상담하십시오."
    
    public static let confirm = "확인"
    public static let cancel = "취소"
    public static let alert: String = "알림"
}

extension Constants.NavigationView {
    static let search: String = "검색"
    static let backward: String = "뒤로"
}

extension Constants.Search {
    public static let copyComplete: String = "복사 완료!"
    
    public static let medicineSeq: String = "품목 일련번호"
    public static let medicineName: String = "품목명"
    public static let entpSeq: String = "업체 일련번호"
    public static let entpName: String = "업체명"
    public static let chart: String = "성상"
    public static let medicineImage: String = "약 이미지"
    public static let printFront: String = "앞면"
    public static let printBack: String = "뒷면"
    public static let medicineShape: String = "모양"
    public static let colorClass1: String = "색상(앞면)"
    public static let colorClass2: String = "색상(뒷면)"
    public static let lineFront: String = "분할선(앞면)"
    public static let lineBack: String = "분할선(뒷면)"
    public static let lengLong: String = "크기(장축)"
    public static let lengShort: String = "크기(단축)"
    public static let thick: String = "크기(두께)"
    public static let imgRegistTs: String = "약학정보원 이미지 생성일"
    public static let classNo: String = "분류번호"
    public static let className: String = "분류명"
    public static let etcOtcName: String = "전문/일반"
    public static let medicinePermitDate: String = "품목허가일자"
    public static let formCodeName: String = "제형코드이름"
    public static let markCodeFrontAnal: String = "마크내용(앞면)"
    public static let markCodeBackAnal: String = "마크내용(뒷면)"
    public static let markCodeFrontImg: String = "마크이미지(앞면)"
    public static let markCodeBackImg: String = "마크이미지(뒷면)"
    public static let changeDate: String = "변경일자"
    public static let markCodeFront: String = "마크코드(앞면)"
    public static let markCodeBack: String = "마크코드(뒷면)"
    public static let medicineEngName: String = "품목영문명"
    public static let ediCode: String = "보험코드"
    public static let hits: String = "조회수"
    
    public static let efcyQestim: String = "효능"
    public static let useMethodQesitm: String = "사용법"
    public static let atpnWarnQesitm: String = "경고"
    public static let atpnQesitm: String = "주의사항"
    public static let intrcQesitm: String = "상호작용"
    public static let seQesitm: String = "부작용"
    public static let depositMethodQesitm: String = "보관법"
}
