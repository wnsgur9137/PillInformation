//
//  NoticeTargetType.swift
//  NetworkInfra
//
//  Created by JunHyeok Lee on 2/15/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import Moya

public enum NoticeTargetType {
    case getAllNotices
    case getNotice(noticeID: Int)
    case setNotice(title: String, writer: String, content: String)
    case updateNotice(noticeID: Int, title: String, content: String)
    case deleteNotice(noticeID: Int)
}

extension NoticeTargetType: MoyaErrorHandleable {
    public var baseURL: URL {
        return URL(string: "")!
    }
    
    public var path: String {
        switch self {
        case .getAllNotices: return "/getAllNotices/"
        case .getNotice: return "/getNotice/"
        case .setNotice: return "/setNotice/"
        case .updateNotice: return "/updateNotice/"
        case .deleteNotice: return "/deleteNotice/"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        // GET
        case .getAllNotices: return .get
        case .getNotice: return .get
        // POST
        case .setNotice: return .post
        case .updateNotice: return .post
        case .deleteNotice: return .post
        }
    }
    
    public var headers: [String : String]? {
        return nil
    }
    
    public var parameters: [String: Any]? {
        switch self {
        case .getAllNotices:
            return nil
            
        case let .getNotice(noticeID):
            return ["id": noticeID]
            
        case let .setNotice(title, writer, content):
            return ["title": title,
                    "writer": writer,
                    "content": content]
            
        case let .updateNotice(noticeID, title, content):
            return ["id": noticeID,
                    "title": title,
                    "content": content]
            
        case let .deleteNotice(noticeID):
            return ["id": noticeID]
        }
    }
    
    public var task: Moya.Task {
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

extension NoticeTargetType {
    public var sampleData: Data {
        switch self {
        case .getAllNotices:
            return Data(
                """
                {
                    "noticeList": [
                        {
                            "writer": "testNickname1",
                            "title": "TestTitle1",
                            "content": "TestContent1"
                        },
                        {
                            "writer": "testNickname2",
                            "title": "TestTitle2",
                            "content": "TestContent2"
                        },
                        {
                            "writer": "testNickname3",
                            "title": "TestTitle3",
                            "content": "TestContent3"
                        },
                        {
                            "writer": "testNickname4",
                            "title": "TestTitle4",
                            "content": "TestContent4"
                        },
                        {
                            "writer": "testNickname5",
                            "title": "TestTitle5",
                            "content": "TestContent5"
                        },
                        {
                            "writer": "testNickname6",
                            "title": "TestTitle6",
                            "content": "TestContent6"
                        },
                    ]
                }
                """.utf8
            )
            
        case .getNotice:
            return Data(
                """
                {
                    "writer": "testNickname",
                    "title": "TestTitle",
                    "content": "TestContent"
                }
                """.utf8
            )
            
        case .setNotice:
            // "success" or "fail"
            return Data(
                """
                {
                    "success"
                }
                """.utf8
            )
            
        case .updateNotice:
            // "success" or "fail"
            return Data(
                """
                {
                    "success"
                }
                """.utf8
            )
            
        case .deleteNotice:
            // "success" or "fail"
            return Data(
                """
                {
                    "success"
                }
                """.utf8
            )
            
        }
    }
}
