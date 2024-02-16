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

final class NetworkManager {
    let userProvider: UserNetworkType
    let pillProvider: PillNetworkType
    let noticeProvider: NoticeNetworkType
    
    init(withTest: Bool = false,
         withFail: Bool = false) {
        if withTest {
            self.userProvider = .stubbingNetworking(needFail: withFail)
            self.pillProvider = .stubbingNetworking(needFail: withFail)
            self.noticeProvider = .stubbingNetworking(needFail: withFail)
        } else {
            self.userProvider = .defaultNetworking()
            self.pillProvider = .defaultNetworking()
            self.noticeProvider = .defaultNetworking()
        }
    }
}
