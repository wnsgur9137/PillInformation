//
//  NetworkManager+Search.swift
//  SearchData
//
//  Created by JunHyeok Lee on 2/27/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RxSwift
import Moya

import NetworkInfra
import SearchDomain

extension NetworkManager {
    public func requestPill(keyword: String) -> Single<PillInfoListResponseDTO> {
        return requestObject(.getPillList(name: keyword), type: PillInfoListResponseDTO.self)
    }
}
