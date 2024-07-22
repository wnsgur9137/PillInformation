//
//  PillTargetType.swift
//  NetworkInfra
//
//  Created by JunHyeok Lee on 2/15/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import Moya

public enum PillTargetType {
    case getPillList(name: String)
    case getPillShapeList(shapes: [String]?,
                          colors: [String]?,
                          lines: [String]?,
                          codes: [String]?)
    case getPillDescription(medicineSeq: Int)
    case getRecommendPillNames
    case getRecommendPills
    case getPillHits(medicineSeq: Int)
    case postPillHits(medicineSeq: Int, medicineName: String)
    case getRecommendKeyword
}

extension PillTargetType: MoyaErrorHandleable {
    public var baseURL: URL {
        return URL(string: "")!
    }
    
    public var path: String {
        switch self {
        case let .getPillList(name): return "/pill/getPillsWithName/\(name)"
        case .getPillShapeList: return "/pill/getPillsWithShapeV1"
        case let .getPillDescription(medicineSeq: medicineSeq): return "/pill/description/\(medicineSeq)"
        case .getRecommendPillNames: return "/recommendMedicineNames"
        case .getRecommendPills: return "/pill/recommendPills"
        case let .getPillHits(medicineSeq): return "/medicineHits/\(medicineSeq)"
        case .postPillHits: return "/medicineHits"
        case .getRecommendKeyword: return "/searchKeyword/recommendKeywords"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        // GET
        case .getPillList: return .get
        case .getPillShapeList: return .get
        case .getPillDescription: return .get
        case .getRecommendPillNames: return .get
        case .getRecommendPills: return .get
        case .getPillHits: return .get
        case .getRecommendKeyword: return .get
            
        // POST
        case .postPillHits: return .post
        }
    }
    
    public var headers: [String : String]? {
        return nil
    }
    
    public var parameters: [String: Any]? {
        switch self {
        case .getPillList:
            return nil
            
        case let .getPillShapeList(shapes, colors, lines, codes):
            var parameters: [String: Any] = [:]
            if let shapes = shapes { parameters["shapes"] = shapes }
            if let colors = colors { parameters["colors"] = colors }
            if let lines = lines { parameters["lines"] = lines }
            if let codes = codes { parameters["codes"] = codes }
            return parameters
            
        case .getPillDescription:
            return nil
            
        case .getRecommendPillNames:
            return nil
            
        case .getRecommendPills:
            return nil
            
        case let .getPillHits(medicineSeq):
            return ["medicineSeq": medicineSeq]
            
        case let .postPillHits(medicineSeq, medicineName):
            return [
                "medicineSeq": medicineSeq,
                "medicineName": medicineName
            ]
            
        case .getRecommendKeyword:
            return nil
        }
    }
    
    public var task: Moya.Task {
        if case .getPillShapeList = self,
           let parameters = parameters {
            let encoding = URLEncoding(destination: .queryString, arrayEncoding: .noBrackets)
            return .requestParameters(parameters: parameters, encoding: encoding)
        }
        
        if method == .get {
            let encoding: URLEncoding = .queryString
            if let parameters = parameters {
                return .requestParameters(parameters: parameters, encoding: encoding)
            }
        }
        let encoding: JSONEncoding = .default
        if let parameters = parameters {
            return .requestParameters(parameters: parameters, encoding: encoding)
        }
        return .requestPlain
    }
}

extension PillTargetType {
    public var sampleData: Data {
        switch self {
        case .getPillList:
            return Data(
                """
                [
                    {
                        "medicineSeq": "195900001",
                        "medicineName": "헤로세친캅셀250밀리그람(클로람페니콜)",
                        "entpSeq": "19650001",
                        "entpName": "(주)종근당",
                        "chart": "이 약은 백색 내지 황백색의 결정 또는 결정성 가루가 들어 있는 상의는 갈색, 하의는 미황색의 캅셀이다.",
                        "medicineImage": "https://nedrug.mfds.go.kr/pbp/cmn/itemImageDownload/154601161228500091",
                        "printFront": "CKD 250",
                        "printBack": "NULL",
                        "medicineShape": "장방형",
                        "colorClass1": "갈색",
                        "colorClass2": "노랑",
                        "lineFront": "NULL",
                        "lineBack": "NULL",
                        "lengLong": "17.60",
                        "lengShort": "6.07",
                        "thick": "6.35",
                        "imgRegistTs": "20041126",
                        "classNo": "06150",
                        "className": "주로 그람양성, 음성균, 리케치아, 비루스에 작용하는 것",
                        "etcOtcName": "전문의약품",
                        "medicinePermitDate": "19590707",
                        "formCodeName": "경질캡슐제, 산제",
                        "markCodeFrontAnal": "",
                        "markCodeBackAnal": "",
                        "markCodeFrontImg": "",
                        "markCodeBackImg": "",
                        "changeDate": "20120829",
                        "markCodeFront": "NULL",
                        "markCodeBack": "NULL",
                        "medicineEngName": "Helocetin Cap.",
                        "ediCode": "NULL"
                    },
                    {
                        "medicineSeq": "195900032",
                        "medicineName": "디크로다이드정25밀리그램(히드로클로로티아지드)",
                        "entpSeq": "19580005",
                        "entpName": "태극제약(주)",
                        "chart": "주황색의 원형정제",
                        "medicineImage": "https://nedrug.mfds.go.kr/pbp/cmn/itemImageDownload/151335258227300060",
                        "printFront": "TG분할선DCT",
                        "printBack": "NULL",
                        "medicineShape": "원형",
                        "colorClass1": "주황",
                        "colorClass2": "NULL",
                        "lineFront": "-",
                        "lineBack": "NULL",
                        "lengLong": "7",
                        "lengShort": "7",
                        "thick": "3",
                        "imgRegistTs": "20050616",
                        "classNo": "02130",
                        "className": "이뇨제",
                        "etcOtcName": "전문의약품",
                        "medicinePermitDate": "19590908",
                        "formCodeName": "나정",
                        "markCodeFrontAnal": "",
                        "markCodeBackAnal": "",
                        "markCodeFrontImg": "",
                        "markCodeBackImg": "",
                        "changeDate": "20140209",
                        "markCodeFront": "NULL",
                        "markCodeBack": "NULL",
                        "medicineEngName": "Dichlodide Tab. 25mg",
                        "ediCode": "NULL"
                    }
                ]
                """.utf8
            )
            
        case .getPillShapeList:
            return Data(
                """
                [
                    {
                        "medicineSeq": "195900001",
                        "medicineName": "헤로세친캅셀250밀리그람(클로람페니콜)",
                        "entpSeq": "19650001",
                        "entpName": "(주)종근당",
                        "chart": "이 약은 백색 내지 황백색의 결정 또는 결정성 가루가 들어 있는 상의는 갈색, 하의는 미황색의 캅셀이다.",
                        "medicineImage": "https://nedrug.mfds.go.kr/pbp/cmn/itemImageDownload/154601161228500091",
                        "printFront": "CKD 250",
                        "printBack": "NULL",
                        "medicineShape": "장방형",
                        "colorClass1": "갈색",
                        "colorClass2": "노랑",
                        "lineFront": "NULL",
                        "lineBack": "NULL",
                        "lengLong": "17.60",
                        "lengShort": "6.07",
                        "thick": "6.35",
                        "imgRegistTs": "20041126",
                        "classNo": "06150",
                        "className": "주로 그람양성, 음성균, 리케치아, 비루스에 작용하는 것",
                        "etcOtcName": "전문의약품",
                        "medicinePermitDate": "19590707",
                        "formCodeName": "경질캡슐제, 산제",
                        "markCodeFrontAnal": "",
                        "markCodeBackAnal": "",
                        "markCodeFrontImg": "",
                        "markCodeBackImg": "",
                        "changeDate": "20120829",
                        "markCodeFront": "NULL",
                        "markCodeBack": "NULL",
                        "medicineEngName": "Helocetin Cap.",
                        "ediCode": "NULL"
                    },
                    {
                        "medicineSeq": "195900032",
                        "medicineName": "디크로다이드정25밀리그램(히드로클로로티아지드)",
                        "entpSeq": "19580005",
                        "entpName": "태극제약(주)",
                        "chart": "주황색의 원형정제",
                        "medicineImage": "https://nedrug.mfds.go.kr/pbp/cmn/itemImageDownload/151335258227300060",
                        "printFront": "TG분할선DCT",
                        "printBack": "NULL",
                        "medicineShape": "원형",
                        "colorClass1": "주황",
                        "colorClass2": "NULL",
                        "lineFront": "-",
                        "lineBack": "NULL",
                        "lengLong": "7",
                        "lengShort": "7",
                        "thick": "3",
                        "imgRegistTs": "20050616",
                        "classNo": "02130",
                        "className": "이뇨제",
                        "etcOtcName": "전문의약품",
                        "medicinePermitDate": "19590908",
                        "formCodeName": "나정",
                        "markCodeFrontAnal": "",
                        "markCodeBackAnal": "",
                        "markCodeFrontImg": "",
                        "markCodeBackImg": "",
                        "changeDate": "20140209",
                        "markCodeFront": "NULL",
                        "markCodeBack": "NULL",
                        "medicineEngName": "Dichlodide Tab. 25mg",
                        "ediCode": "NULL"
                    }
                ]
                """.utf8
            )
            
        case .getPillDescription:
            return Data(
                """
                {
                    "drugSeq": "195700020",
                    "drugName": "활명수",
                    "entpName": "동화약품(주)",
                    "efcyQestim": "이 약은 식욕감퇴(식욕부진), 위부팽만감, 소화불량, 과식, 체함, 구역, 구토에 사용합니다.",
                    "useMethodQestim": "만 15세 이상 및 성인은 1회 1병(75 mL), 만 11세이상~만 15세미만은 1회 2/3병(50 mL), 만 8세 이상~만 11세 미만은 1회 1/2병(37.5 mL), 만 5세 이상~만 8세 미만은 1회 1/3병(25 mL), 만 3세 이상~만 5세 미만은 1회 1/4병(18.75 mL), 만 1세 이상~만 3세 미만은 1회 1/5병(15 mL), 1일 3회 식후에 복용합니다.",
                    "atpnWarnQesitm": "NULL",
                    "atpnQestim": "만 3개월 미만의 젖먹이는 이 약을 복용하지 마십시오.이 약을 복용하기 전에 만 1세 미만의 젖먹이, 임부 또는 임신하고 있을 가능성이 있는 여성, 카라멜에 과민증 환자 또는 경험자, 나트륨 제한 식이를 하는 사람은 의사 또는 약사와 상의하십시오.정해진 용법과 용량을 잘 지키십시오.어린이에게 투여할 경우 보호자의 지도 감독하에 투여하십시오.1개월 정도 복용하여도 증상의 개선이 없을 경우 복용을 즉각 중지하고 의사 또는 약사와 상의하십시오.",
                    "intrcQestim": "NULL",
                    "seQestim": "NULL",
                    "depositMethodQestim": "습기와 빛을 피해 실온에서 보관하십시오.어린이의 손이 닿지 않는 곳에 보관하십시오.",
                    "openDe": "2021-01-29 00:00:00",
                    "updateDe": "2021November25th",
                    "drugImage": "NULL"
                }
                """.utf8
            )
            
        case .getRecommendPillNames:
            return Data(
                """
                [
                    "타이레놀",
                    "테스트레놀",
                    "또있넹"
                ]
                """.utf8
            )
            
        case .getRecommendPills:
            return Data(
                """
                [
                    {
                        "medicineSeq": "195900001",
                        "medicineName": "헤로세친캅셀250밀리그람(클로람페니콜)",
                        "entpSeq": "19650001",
                        "entpName": "(주)종근당",
                        "chart": "이 약은 백색 내지 황백색의 결정 또는 결정성 가루가 들어 있는 상의는 갈색, 하의는 미황색의 캅셀이다.",
                        "medicineImage": "https://nedrug.mfds.go.kr/pbp/cmn/itemImageDownload/154601161228500091",
                        "printFront": "CKD 250",
                        "printBack": "NULL",
                        "medicineShape": "장방형",
                        "colorClass1": "갈색",
                        "colorClass2": "노랑",
                        "lineFront": "NULL",
                        "lineBack": "NULL",
                        "lengLong": "17.60",
                        "lengShort": "6.07",
                        "thick": "6.35",
                        "imgRegistTs": "20041126",
                        "classNo": "06150",
                        "className": "주로 그람양성, 음성균, 리케치아, 비루스에 작용하는 것",
                        "etcOtcName": "전문의약품",
                        "medicinePermitDate": "19590707",
                        "formCodeName": "경질캡슐제, 산제",
                        "markCodeFrontAnal": "",
                        "markCodeBackAnal": "",
                        "markCodeFrontImg": "",
                        "markCodeBackImg": "",
                        "changeDate": "20120829",
                        "markCodeFront": "NULL",
                        "markCodeBack": "NULL",
                        "medicineEngName": "Helocetin Cap.",
                        "ediCode": "NULL"
                    },
                    {
                        "medicineSeq": "195900032",
                        "medicineName": "디크로다이드정25밀리그램(히드로클로로티아지드)",
                        "entpSeq": "19580005",
                        "entpName": "태극제약(주)",
                        "chart": "주황색의 원형정제",
                        "medicineImage": "https://nedrug.mfds.go.kr/pbp/cmn/itemImageDownload/151335258227300060",
                        "printFront": "TG분할선DCT",
                        "printBack": "NULL",
                        "medicineShape": "원형",
                        "colorClass1": "주황",
                        "colorClass2": "NULL",
                        "lineFront": "-",
                        "lineBack": "NULL",
                        "lengLong": "7",
                        "lengShort": "7",
                        "thick": "3",
                        "imgRegistTs": "20050616",
                        "classNo": "02130",
                        "className": "이뇨제",
                        "etcOtcName": "전문의약품",
                        "medicinePermitDate": "19590908",
                        "formCodeName": "나정",
                        "markCodeFrontAnal": "",
                        "markCodeBackAnal": "",
                        "markCodeFrontImg": "",
                        "markCodeBackImg": "",
                        "changeDate": "20140209",
                        "markCodeFront": "NULL",
                        "markCodeBack": "NULL",
                        "medicineEngName": "Dichlodide Tab. 25mg",
                        "ediCode": "NULL"
                    }
                ]
                """.utf8
            )
            
        case .getPillHits:
            return Data(
            """
            "medicine_seq": 123456,
            "medicine_name": "테스트레놀",
            "hits": 1
            """.utf8
            )
            
        case .postPillHits:
            return Data(
            """
            "medicine_seq": 123456,
            "medicine_name": "테스트레놀",
            "hits": 1
            """.utf8
            )
        case .getRecommendKeyword:
            return Data(
            """
            [
                "검색어1",
                "하핳헿",
                "테스트테스트",
                "호이",
                "열글자열글자열글자열"
            ]
            """.utf8
            )
        }
    }
}
