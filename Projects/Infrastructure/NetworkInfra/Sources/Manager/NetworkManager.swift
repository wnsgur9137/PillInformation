//
//  NetworkManager.swift
//  NetworkInfra
//
//  Created by JunHyeok Lee on 2/16/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Moya

public final class NetworkManager {
    let userProvider: UserNetworkType
    let pillProvider: PillNetworkType
    let noticeProvider: NoticeNetworkType
    
    public init(withTest: Bool,
         withFail: Bool,
         baseURL: String) {
        if withTest {
            self.userProvider = .stubbingNetworking(baseURL: baseURL, needFail: withFail)
            self.pillProvider = .stubbingNetworking(baseURL: baseURL, needFail: withFail)
            self.noticeProvider = .stubbingNetworking(baseURL: baseURL, needFail: withFail)
        } else {
            self.userProvider = .defaultNetworking(baseURL: baseURL)
            self.pillProvider = .defaultNetworking(baseURL: baseURL)
            self.noticeProvider = .defaultNetworking(baseURL: baseURL)
        }
    }
}
