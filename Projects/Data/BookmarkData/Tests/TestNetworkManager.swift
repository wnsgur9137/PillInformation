//
//  TestNetworkManager.swift
//  BookmarkDataTests
//
//  Created by JunHyoek Lee on 8/26/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation

@testable import NetworkInfra

final class test_NetworkManager {
    let networkManager: NetworkManager
    
    init(withFail: Bool) {
        networkManager = NetworkManager(withTest: true, withFail: withFail, baseURL: "")
    }
}
