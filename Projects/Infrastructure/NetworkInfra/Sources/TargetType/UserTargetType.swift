//
//  UserTargetType.swift
//  NetworkInfra
//
//  Created by JunHyeok Lee on 2/15/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import Moya

public enum UserTargetType {
    case getUserInfo(email: String)
    case signin(token: String)
    
    case getNicknameCheck(nickname: String)
    case postUserInfo(email: String, nickname: String, updateDate: String)
    case updateUserInfo(email: String, nickname: String, updateDate: String)
    case deleteUser(email: String)
}

extension UserTargetType: MoyaErrorHandleable {
    public var baseURL: URL {
        return URL(string: "")!
    }
    
    public var path: String {
        switch self {
        case .getUserInfo: return "/user/userInfo"
        case .signin: return "/user/signin"
        case .getNicknameCheck: return "/getNicknameCheck/"
        case .postUserInfo: return "/setUserInfo/"
        case .updateUserInfo: return "/updateUserInfo/"
        case .deleteUser: return "/deleteUserInfo/"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        // GET
        case .getUserInfo: return .get
            
        case .getNicknameCheck: return .get
        // POST
        case .signin: return .post
            
        case .postUserInfo: return .post
        case .updateUserInfo: return .post
        case .deleteUser: return .post
        }
    }
    
    public var headers: [String : String]? {
        if case let .signin(token) = self {
            return ["token": "Bearer \(token)"]
        }
        return nil
    }
    
    public var parameters: [String: Any]? {
        switch self {
        case let .getUserInfo(email):
            return ["email": email]
            
        case .signin:
            return nil
            
        case let .getNicknameCheck(nickname):
            return ["nickname": nickname]
            
        case let .postUserInfo(email, nickname, updateDate):
            return ["email": email,
                    "nickname": nickname,
                    "updateDate": updateDate]
            
        case let .updateUserInfo(email, nickname, updateDate):
            return ["email": email,
                    "nickname": nickname,
                    "updateDate": updateDate]
            
        case let .deleteUser(email):
            return ["email": email]
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

extension UserTargetType {
    public var sampleData: Data {
        switch self {
        case .signin:
            return Data()
            
        case .getUserInfo:
            return Data(
                """
                {
                    "email": "test@test.com",
                    "nickname": "testNickname",
                    "updateDate": "updateDate"
                }
                """.utf8
            )
            
        case .getNicknameCheck:
            return Data(
                """
                {
                    "email": "test@test.com",
                    "nickname": "testNickname",
                    "updateDate": "updateDate"
                }
                """.utf8
            )
            
        case .postUserInfo:
            // "success" or "fail"
            return Data(
                """
                {
                    "success"
                }
                """.utf8
            )
            
        case .updateUserInfo:
            // "success" or "fail"
            return Data(
                """
                {
                    "success"
                }
                """.utf8
            )
            
        case .deleteUser:
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
