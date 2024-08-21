//
//  Test.swift
//  ProjectDescriptionHelpers
//
//  Created by JunHyeok Lee on 4/12/24.
//

import XCTest

@testable import InjectionManager
@testable import NetworkInfra

final class test_NetworkManager {
    
    let networkManager: NetworkManager
    
    init(withFail: Bool) {
        networkManager = NetworkManager(withTest: true, withFail: withFail, baseURL: "")
    }
}
