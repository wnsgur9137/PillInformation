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
    case signin(identifier: String)
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
        case .signin: return "/user/signin"
        case .updateUser: return "/user/update"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        // GET
        case .getUser: return .get
            
        // POST
        case .signin: return .post
        case .updateUser: return .post
        }
    }
    
    public var headers: [String : String]? {
        switch self {
        case let .getUser(token):
            return ["token": "\(token)"]
            
        case let .signin(identifier):
            return ["token": "\(identifier)"]
            
        case let .updateUser(_, _, _, _, _, token):
            return ["token": "\(token)"]
            
        default:
            return nil
        }
    }
    
    public var parameters: [String: Any]? {
        switch self {
        case .getUser:
            return nil
            
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
