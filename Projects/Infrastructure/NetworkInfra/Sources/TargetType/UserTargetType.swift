//
//  UserTargetType.swift
//  NetworkInfra
//
//  Created by JunHyeok Lee on 2/15/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import Moya

enum UserTargetType {
    case getUserInfo(email: String)
    case getNicknameCheck(nickname: String)
    case postUserInfo(email: String, nickname: String, updateDate: String)
    case updateUserInfo(email: String, nickname: String, updateDate: String)
    case deleteUser(email: String)
}

extension UserTargetType: MoyaErrorHandleable {
    var baseURL: URL {
        return URL(string: "")!
    }
    
    var path: String {
        switch self {
        case .getUserInfo: return "/getUserInfo/"
        case .getNicknameCheck: return "/getNicknameCheck/"
        case .postUserInfo: return "/setUserInfo/"
        case .updateUserInfo: return "/updateUserInfo/"
        case .deleteUser: return "/deleteUserInfo/"
        }
    }
    
    var method: Moya.Method {
        switch self {
        // GET
        case .getUserInfo: return .get
        case .getNicknameCheck: return .get
        // POST
        case .postUserInfo: return .post
        case .updateUserInfo: return .post
        case .deleteUser: return .post
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    var parameters: [String: Any]? {
        switch self {
        case let .getUserInfo(email): 
            return ["email": email]
            
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
    
    var task: Moya.Task {
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
    var dummyData: Data {
        switch self {
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
