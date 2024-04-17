//
//  NetworkManager+Home.swift
//  HomeData
//
//  Created by JunHyeok Lee on 2/19/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Moya

import NetworkInfra
import HomeDomain

extension NetworkManager {
    public func requestNotices() -> Single<[NoticeResponseDTO]> {
        return requestObject(.getAllNotices, type: [NoticeResponseDTO].self)
    }
}
