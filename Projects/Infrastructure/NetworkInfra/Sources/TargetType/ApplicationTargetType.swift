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
}

extension ApplicationTargetType: MoyaErrorHandleable {
    public var baseURL: URL {
        return URL(string: "")!
    }
    
    public var path: String {
        switch self {
        case .isNeedSignIn: return "/isNeedSignIn"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .isNeedSignIn: return .get
        }
    }
    
    public var headers: [String : String]? {
        switch self {
        case .isNeedSignIn: return nil
        }
    }
    
    public var parameters: [String: Any]? {
        switch self {
        case .isNeedSignIn: return nil
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
        }
    }
}
