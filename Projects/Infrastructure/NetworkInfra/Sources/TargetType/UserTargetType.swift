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
    case getUser(token: String)
    case signup(identifier: String, social: String)
    case signin(accessToken: String)
    case updateUser(appPolicy: Bool,
                    agePolicy: Bool,
                    privacyPolicy: Bool,
                    daytimeNoti: Bool,
                    nighttimeNoti: Bool,
                    token: String)
}

extension UserTargetType: MoyaErrorHandleable {
    public var baseURL: URL {
        return URL(string: "")!
    }
    
    public var path: String {
        switch self {
        case .getUser: return "/user/userInfo"
        case .signup: return "/user/signup"
        case .signin: return "/user/signin"
        case .updateUser: return "/user/update"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        // GET
        case .getUser: return .get
        case .signin: return .get
            
        // POST
        case .signup: return .post
        case .updateUser: return .post
        }
    }
    
    public var headers: [String : String]? {
        switch self {
        case let .getUser(token):
            return ["accessToken": "\(token)"]
            
        case let .signup(identifier, _):
            return ["identifier": "\(identifier)"]
            
        case let .signin(accessToken):
            return ["accessToken": "\(accessToken)"]
            
        case let .updateUser(_, _, _, _, _, token):
            return ["accessToken": "\(token)"]
        }
    }
    
    public var parameters: [String: Any]? {
        switch self {
        case .getUser:
            return nil
            
        case let .signup(_, social):
            return ["social": "\(social)"]
            
        case .signin:
            return nil
            
        case let .updateUser(appPolicy, agePolicy, privacyPolicy, daytimeNoti, nighttimeNoti, _):
            return [
                "is_agree_app_policy": appPolicy,
                "is_agree_age_policy": agePolicy,
                "is_agree_privacy_policy": privacyPolicy,
                "is_agree_daytime_noti": daytimeNoti,
                "is_agree_nighttime_noti": nighttimeNoti
            ]
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
        case .signup:
            return Data()
            
        case .signin:
            return Data()
            
        case .getUser:
            return Data(
                """
                {
                    "email": "test@test.com",
                    "nickname": "testNickname",
                    "updateDate": "updateDate"
                }
                """.utf8
            )
            
        case .updateUser:
            return Data()
        }
    }
}
