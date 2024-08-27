//
//  TestNetworkManager.swift
//  MyPageDataTests
//
//  Created by JunHyoek Lee on 8/27/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation

import NetworkInfra

final class test_NetworkManager {
    let networkManager: NetworkManager
    
    init(withFail: Bool) {
        self.networkManager = NetworkManager(withTest: true, withFail: withFail, baseURL: "")
    }
}
