//
//  NetworkManager+Home.swift
//  HomeData
//
//  Created by JunHyeok Lee on 2/19/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import NetworkInfra
import HomeDomain

import Foundation
import RxSwift
import RxCocoa
import Moya

public extension NetworkManager {
    func requestNotices() -> Single<NoticeListResponseDTO> {
        return requestObject(.getAllNotices, type: NoticeListResponseDTO.self)
    }
}
