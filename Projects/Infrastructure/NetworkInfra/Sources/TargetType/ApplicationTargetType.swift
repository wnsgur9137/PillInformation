//
//  ApplicationTargetType.swift
//  NetworkInfra
//
//  Created by JunHyeok Lee on 7/19/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import Moya

public enum ApplicationTargetType {
    case isNeedSignIn
    case isShowAlarmTab
}

extension ApplicationTargetType: MoyaErrorHandleable {
    public var baseURL: URL {
        return URL(string: "")!
    }
    
    public var path: String {
        switch self {
        case .isNeedSignIn: return "/isNeedSignIn"
        case .isShowAlarmTab: return "/isShowAlarmTab"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .isNeedSignIn: return .get
        case .isShowAlarmTab: return .get
        }
    }
    
    public var headers: [String : String]? {
        switch self {
        case .isNeedSignIn: return nil
        case .isShowAlarmTab: return nil
        }
    }
    
    public var parameters: [String: Any]? {
        switch self {
        case .isNeedSignIn: return nil
        case .isShowAlarmTab: return nil
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

extension ApplicationTargetType {
    public var sampleData: Data {
        switch self {
        case .isNeedSignIn:
            return Data(
                """
                true
                """.utf8
            )
            
        case .isShowAlarmTab:
            return Data(
                """
                true
                """.utf8
            )
        }
    }
}
