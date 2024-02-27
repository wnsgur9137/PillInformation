//
//  DefaultHomeRepository.swift
//  HomeData
//
//  Created by JUNHYEOK LEE on 2/17/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import HomeDomain
import NetworkInfra

import Foundation
import RxSwift
import RxCocoa

public final class DefaultNoticeRepository: NoticeRepository {
    private let networkManager: NetworkManager
    private let disposeBag = DisposeBag()
    
    public init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
}

extension DefaultNoticeRepository {
    public func executeNotices() -> Single<[Notice]> {
        return networkManager.requestNotices().map { noticeListResponseDTO in
            return noticeListResponseDTO.noticeList.map { $0.toDomain() }
        }
    }
}
